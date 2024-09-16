from mlir import ir, passmanager, execution_engine
from mlir.dialects import func, arith

import numpy as np

import ctypes

def create_abs(ctx : ir.Context):
    with ctx, ir.Location.unknown():
        module = ir.Module.create()
        with ir.InsertionPoint(module.body):
            i32 = ir.IntegerType.get_signless(32)
            func_type = ir.FunctionType.get([], [i32])
            func_op = func.FuncOp(name="abs", type=func_type, visibility="public")
            entry_block = func_op.add_entry_block()
            with ir.InsertionPoint(entry_block):
                zero = arith.ConstantOp(result=i32, value=0)
                return_op = func.ReturnOp(zero)
        return module

# def create_stablehlo(ctx : ir.Context):
#     with ctx, ir.Location.unknown():
#         module = ir.Module.create()
#         with ir.InsertionPoint(module.body):
#             lhs_tensor_type = ir.RankedTensorType.get(shape=[1000, 2048], element_type=ir.F32Type.get())
#             rhs_tensor_type = ir.RankedTensorType.get(shape=[2048, 1000], element_type=ir.F32Type.get())
#             out_tensor_type = ir.RankedTensorType.get(shape=[1000, 1000], element_type=ir.F32Type.get())
#             func_type = ir.FunctionType.get([lhs_tensor_type, rhs_tensor_type], [out_tensor_type])
#             func_op = func.FuncOp(name="matmul", type=func_type)
#             entry_block = func_op.add_entry_block()
#             with ir.InsertionPoint(entry_block):
#                 lhs = func_op.arguments[0]
#                 rhs = func_op.arguments[1]
#                 matmul_op = stablehlo.DotOp(result=out_tensor_type, lhs=lhs, rhs=rhs)
#                 return_op = func.ReturnOp(matmul_op)
#         return module

if __name__ == '__main__':
    ctx = ir.Context()
    ctx.allow_unregistered_dialects = True
    mod = create_abs(ctx)
    print(mod)
    # mod = create_stablehlo(ctx)
    pipeline_str = """
        builtin.module(
            convert-arith-to-llvm,
            convert-func-to-llvm,
            reconcile-unrealized-casts
        )
    """
    pm = passmanager.PassManager.parse(pipeline_str, ctx)
    pm.run(mod.operation)
    print(mod)
    exe = execution_engine.ExecutionEngine(mod, opt_level=3)
    abs_func = exe.lookup("abs")
    # result = abs_func(ctypes.c_int32(42))
    # print("Result:", result)
    
    


        
        

    

    