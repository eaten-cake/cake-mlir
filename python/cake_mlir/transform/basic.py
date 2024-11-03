from cake_mlir import passmanager
from cake_mlir.ds import IRModule

class Pass:

    def __init__(self):
        pass

    def run(self, module : IRModule) -> IRModule:
        pass

    def __call__(self, module : IRModule) -> IRModule:
        return self.run(module)
    
class Sequential:

    def __init__(self, passes : list = []):
        self.passes = list
    
    def __call__(self, module : IRModule) -> IRModule:
        for p in self.passes:
            module = p(module)
        return module
    


