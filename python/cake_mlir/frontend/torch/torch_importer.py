from cake_mlir.extras import fx_importer
from cake_mlir.extras.fx_decomp_util import get_decomposition_table
from cake_mlir.ir import Context, UnitAttr, Module
from cake_mlir.passmanager import PassManager
from cake_mlir.dialects import torch as torch_dialect
from ... import transform

import torch

from typing import Union, Tuple, Any, Optional

def from_torch(
        model : Union[torch.export.ExportedProgram, torch.nn.Module],
        args : Optional[Tuple[Any, ...]] = None
) -> Module:
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
        func_name="forward"
    )

    operation.attributes["llvm.emit_c_interface"] = UnitAttr.get(operation.context)
    
    passes = [
        "torchdynamo-export-to-torch-backend-pipeline",
        "torch-backend-to-linalg-on-tensors-backend-pipeline",
        # "torch-backend-to-stablehlo-backend-pipeline",
    ]

    pipeline_str = transform.sequential(passes)

    pm = PassManager.parse(pipeline_str, ctx)
    pm.run(importer.module.operation)
    return importer.module




    
