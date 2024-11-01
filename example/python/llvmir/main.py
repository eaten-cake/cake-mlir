from cake_mlir import ir, passmanager
from cake_mlir.dialects import llvm, func

def main():
    ctx = ir.Context()
    with ctx, ir.Location.unknown() as loc:
        ptr_type = llvm.PointerType.get()
        func_type = ir.FunctionType.get([ptr_type], [ptr_type])
        module = ir.Module.create()
        with ir.InsertionPoint(module.body):
            func_op = func.FuncOp("func_test", func_type)
            entry = func_op.add_entry_block()
            with ir.InsertionPoint(entry):
                # return_op = llvm.ReturnOp([ptr_type])
                args = entry.arguments
                return_op = func.ReturnOp([args[0]])
            pm = passmanager.PassManager.parse("builtin.module(convert-func-to-llvm)")
            pm.run(module.operation)
            print(module)
        

if __name__ == '__main__':
    main()