from cake_mlir.dialects import tosa
from cake_mlir import ir
from cake_mlir.ir import Context, Module, Location

with Context() as ctx, Location.unknown():
    module = Module.create()
    with ir.InsertionPoint(module.body):
        f32 = ir.F32Type.get()
        data_tensor = ir.RankedTensorType.get([1, 3, 224, 224], f32)
        weight_tensor = ir.RankedTensorType.get([16, 3, 3, 3], f32)
        func_type = ir.FunctionType.get()
