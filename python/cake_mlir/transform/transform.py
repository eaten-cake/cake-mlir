from cake_mlir import passmanager
from cake_mlir.ir import Module

def lowering_to_llvm(module : Module) -> Module:

    passes = [
        "stablehlo-legalize-to-linalg",
        "convert-shape-to-std",

        # "canonicalize",
        # "convert-elementwise-to-linalg",
        # "convert-tensor-to-linalg",

        # "one-shot-bufferize{bufferize-function-boundaries}",
        # "buffer-deallocation-pipeline",

        # "convert-linalg-to-affine-loops",
        # "lower-affine",

        # "expand-strided-metadata",

        # "convert-scf-to-cf",
        # "convert-cf-to-llvm",
        # "convert-math-to-llvm",
        # "convert-arith-to-llvm",
        # "convert-func-to-llvm",
        # "finalize-memref-to-llvm",
        # "reconcile-unrealized-casts",
    ]

    pipeline_str = "builtin.module(" + ",".join(passes) + ")"

    with module.context as ctx:
        pm = passmanager.PassManager.parse(pipeline_str)
        pm.run(module.operation)
    return module