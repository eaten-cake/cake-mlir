from cake_mlir import ir

from cake_mlir.structure import IRModule
from .transform import *

def build(module : ir.Module) -> IRModule:
    tosa_mod = module
    linalg_mod = lowering_to_linalg(tosa_mod)
    llvm_mod = lowering_to_llvm(linalg_mod)
    return IRModule(llvm_mod)
