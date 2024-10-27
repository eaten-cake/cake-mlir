import cake_mlir as mlc
from cake_mlir import passmanager
from cake_mlir.ir import Module

import subprocess

TOSA_TO_LINALG_PASS = ",".join(
    [
        # TOSA legalization may emit tosa.const() ops. These are legalized
        # by tosa-to-arith to arith.constants. This mechanical transformation
        # must be done prior to TOSA-to-LinAlg so that the latter does not fail.
        # This is an artifact of legalizations spread across a collection of simple
        # ones in TOSA-to-Standard and the main conversions TOSA-to-LinAlg,
        # that depend on TOSA as well as TOSA-to-Standard.
        "tosa-to-arith",
        "tosa-to-scf",
        # Named ops must be legalized prior to general tosa-to-linalg
        "tosa-to-linalg-named",
        # TOSA-to-LinAlg may generate tosa.const() ops, so we want to lower them
        # to arith.constants here before proceeding further.
        "tosa-to-linalg",
        "tosa-to-tensor",
        "tosa-to-arith",
    ]
)

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

def lowering_to_llvmir(module : Module) -> str:
    command = "cake-translate --mlir-to-llvmir"
    result = subprocess.run(command, shell=True, text=True, capture_output=True, input=str(module))
    return (result.stdout, result.stderr)

def compile2lib(mod, runtime_lib : str):
    command = "llc -filetype=obj -relocation-model=pic -o model.o"
    result = subprocess.run(command, shell=True, text=True, capture_output=True, input=str(mod))
    link_command = f"clang++ -shared -fPIC -o model.so model.o -L{runtime_lib} -lcake_runtime"
    result = subprocess.run(link_command, shell=True, text=True, capture_output=True)
    return (result.stdout, result.stderr)


