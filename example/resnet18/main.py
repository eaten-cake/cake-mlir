import torch
import torchvision

import cake_mlir as mlc
from cake_mlir import ir
from cake_mlir.dialects import tosa, arith, func

import numpy as np

def test_mlir():
    with ir.Context() as ctx, ir.Location.unknown():

        module = ir.Module.create()

        f32 = ir.F32Type.get()

        with ir.InsertionPoint(module.body):
            input_tensor = ir.RankedTensorType.get([1, 10], f32)
            func_type = ir.FunctionType.get([input_tensor], [input_tensor])
            func_op = func.FuncOp(name="test_func", type=func_type)
            with ir.InsertionPoint(func_op.add_entry_block()):
                element_attr = ir.DenseResourceElementsAttr.get_from_buffer(
                    np.random.uniform(0, 1, size=(1, 10)),
                    "tensor_test",
                    ir.RankedTensorType.get([1, 10], f32),
                )
                tosa_const = tosa.const(element_attr)

                args = func_op.entry_block.arguments
                input1 = args[0]
                tosa_add = tosa.add(func_op.type.results[0], input1, tosa_const)
                return_op = func.ReturnOp([tosa_add])

    for op in module.body.operations:
        if isinstance(op, func.FuncOp):
            print(op.type)

def main(): 

    # test_mlir()
    # exit(0)

    model = torchvision.models.resnet18()
    model = model.eval()

    x = torch.zeros((1, 3, 224, 224))
    y = model(x)
    print(y.flatten()[0:10])


    input_shape = (1, 3, 224, 224)
    output_shape = (1, 1000)

    input = torch.randn(input_shape)
    
    mod = mlc.frontend.from_torch(model, (input,))

    mod.operation.print(
        file=open("resnet18.mlir", "w")
    )

    mod = mlc.transform.lowering_to_llvm(mod)

    mod.operation.print(
        file=open("resnet18_llvm.mlir", "w")
    )

    llvmir, _ = mlc.transform.lowering_to_llvmir(mod)

    out, err = mlc.transform.compile2lib(llvmir, "/home/yrx/develop/cake-mlir/build/lib")

    



if __name__ == '__main__':
    main()