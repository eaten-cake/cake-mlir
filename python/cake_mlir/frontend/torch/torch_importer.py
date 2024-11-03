from cake_mlir.extras import fx_importer
from cake_mlir.extras.fx_decomp_util import get_decomposition_table
from cake_mlir import ir
from cake_mlir.ir import Context, UnitAttr, Module
from cake_mlir.passmanager import PassManager
from cake_mlir.dialects import torch as torch_dialect, func, tosa
from cake_mlir import transform
from cake_mlir import utils
from cake_mlir.ds import IRModule

import torch
import torch.utils._pytree as pytree

import numpy as np

from typing import Union, Tuple, Any, Optional

def from_torch(
        model : Union[torch.export.ExportedProgram, torch.nn.Module],
        args : Optional[Tuple[Any, ...]] = None
) -> IRModule:
    ctx = Context()
    torch_dialect.register_dialect(ctx)
    importer = fx_importer.FxImporter(context=ctx)

    if isinstance(model, torch.export.ExportedProgram):
        prog = model
    else:
        if args is None:
            raise ValueError("'args' must be provided when model is a torch.nn.Module")
        prog = torch.export.export(model, args)

    decomposition_table = get_decomposition_table()
    prog = prog.run_decompositions(decomposition_table)

    operation = importer.import_frozen_program(
        prog,
        func_name="__cake_forward__"
    )
    
    passes = [
        "torchdynamo-export-to-torch-backend-pipeline",
        "torch-backend-to-tosa-backend-pipeline",
    ]

    pipeline_str = transform.sequential(passes)

    pm = PassManager.parse(pipeline_str, ctx)
    pm.run(importer.module.operation)

    buffers = dict(model.named_buffers(remove_duplicate=False))
    params_flat, params_spec = pytree.tree_flatten(buffers)
    params_flat = list(params_flat)

    mod = importer.module

    forward_func_op = None
    for op in mod.body.operations:
        if isinstance(op, func.FuncOp) and op.name.value == "__cake_forward__":
            forward_func_op = op
            break

    with mod.context as ctx, ir.Location.unknown():
        buffers_list = []
        for param in params_flat:
            dtype = param.numpy().dtype
            shape = [d for d in param.shape]
            array = np.array(param.numpy())
            if shape == []:
                dense_attr = ir.DenseElementsAttr.get(
                    array,
                    type=utils.create_mlir_dtype(dtype, ctx),
                    shape=[]
                )
                # array = np.array([array])
                buffers_list.append(dense_attr)
            else:
                element_type = utils.create_mlir_dtype(dtype, ctx)
                element_attr = ir.DenseResourceElementsAttr.get_from_buffer(
                    array,
                    name=f"cake_tensor_{str(dtype)}",
                    type=ir.RankedTensorType.get(shape, element_type)
                )
                buffers_list.append(element_attr)
        
        with ir.InsertionPoint(mod.body):
            inputs = []
            for arg in args:
                tensor_type = ir.RankedTensorType.get(
                    [d for d in arg.shape], utils.create_mlir_dtype(arg.numpy().dtype, ctx)
                )
                inputs.append(tensor_type)
            results = [forward_func_op.type.results[0]]
            cake_run_func_type = ir.FunctionType.get(inputs, results)
            cake_run_func_op = func.FuncOp("cake_run", cake_run_func_type)
            entry_block = cake_run_func_op.add_entry_block()
            with ir.InsertionPoint(entry_block):
                call_list = []
                for buffer in buffers_list:
                    tosa_const = tosa.const(buffer)
                    call_list.append(tosa_const)
                input_args = cake_run_func_op.arguments
                call_list.extend(input_args)
                call_func_op = func.CallOp(forward_func_op, call_list)
                return_op = func.ReturnOp([call_func_op])
        mod.operation.regions[0].blocks[0].operations[1].attributes["llvm.emit_c_interface"] = UnitAttr.get()
                

    return IRModule(mod)




    
