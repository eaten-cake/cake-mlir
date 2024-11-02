from cake_mlir import passmanager
from cake_mlir.structure import IRModule

class Pass:

    def __init__(self):
        pass

    def run(self, module : IRModule) -> IRModule:
        pass

    def __call__(self, module : IRModule) -> IRModule:
        return self.run(module)
    
class Sequential:

    def __init__(self):
        self.passes = []

