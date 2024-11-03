from cake_mlir import passmanager
from cake_mlir.ds import IRModule

from ..basic import Pass
from ..transform import sequential

class TosaToLinalgPass(Pass):

    def __init__(self):
        super().__init__()

    def run(self, module : IRModule):
        passes = [
            # convert tosa to linalg on tensors
            "canonicalize",
            "func.func(tosa-infer-shapes)",
            "func.func(tosa-make-broadcastable)",
            "func.func(tosa-to-linalg-named)",
            "canonicalize",
            "func.func(tosa-layerwise-constant-fold)",
            "func.func(tosa-make-broadcastable)",
            "func.func(tosa-to-linalg)",

            "func.func(tosa-to-tensor)",
            "func.func(tosa-to-arith)",
        ]
        pipeline_str = sequential(passes)
        pm = passmanager.PassManager.parse(pipeline_str, module.context)
        pm.run(module.module.operation)
        return module

class LinalgToLLVMPass(Pass):

    def __init__(self):
        super().__init__()

    def run(self, module : IRModule):
        passes = [
            # convert linalg to llvm
            "convert-shape-to-std",

            "canonicalize",
            "convert-elementwise-to-linalg",
            "convert-tensor-to-linalg",

            "one-shot-bufferize{bufferize-function-boundaries}",
            "buffer-deallocation-pipeline",

            "convert-linalg-to-affine-loops",

            "expand-strided-metadata",
            "lower-affine",

            "convert-scf-to-cf",
            "convert-cf-to-llvm",
            "convert-math-to-llvm",
            "convert-arith-to-llvm",
            "convert-func-to-llvm",
            "finalize-memref-to-llvm",
            "reconcile-unrealized-casts",
            # clean up
            "canonicalize",
            "sccp",
            "cse",
            "symbol-dce",
        ]

        pipeline_str = sequential(passes)
        pm = passmanager.PassManager.parse(pipeline_str, module.context)
        pm.run(module.module.operation)
        return module



