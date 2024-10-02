from cake_mlir import passmanager
from cake_mlir.ir import Module

def sequential(passes : list) -> str:
    return "builtin.module(" + ",".join(passes) + ")"

def lowering_to_llvm(module : Module) -> Module:

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
    ]

    pipeline_str = sequential(passes)

    with module.context as ctx:
        pm = passmanager.PassManager.parse(pipeline_str)
        pm.run(module.operation)
    return module