from .._mlir_libs._cakePythonTest import TestAdd

class Add(TestAdd):

    def __init__(self, a, b):
        super().__init__(a, b)

    def add(self):
        return super().add()

