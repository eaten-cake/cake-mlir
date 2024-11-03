from cake_mlir import ir

from cake_mlir.ds import IRModule
from .transform import *
from .passes import *

def build(module : IRModule) -> IRModule:
    tosa_mod = module
    tosa_mod.export("tosa.mlir")
    tosa2linalg = TosaToLinalgPass()
    linalg2llvm = LinalgToLLVMPass()
    linalg_mod = tosa2linalg(tosa_mod)
    linalg_mod.export("linalg.mlir")
    llvm_mod = linalg2llvm(linalg_mod)
    llvm_mod.export("llvm.mlir")
    return llvm_mod
