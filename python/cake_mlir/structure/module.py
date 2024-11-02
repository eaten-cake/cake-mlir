from cake_mlir import ir

# IRModule represents an MLIR module.
class IRModule:

    def __init__(self, module : ir.Module):
        self.module = module

    def __str__(self):
        return str(self.module)
    
    def export(self, filename : str):
        self.module.operation.print(
            file=open(filename, "w")
        )

class Pass:

    def __init__(self):
        pass

    def run(self, module : IRModule) -> IRModule:
        pass

    def __call__(self, module : IRModule) -> IRModule:
        return self.run(module)
    
class Sequential:

    def __init__(self):
        pass
    

