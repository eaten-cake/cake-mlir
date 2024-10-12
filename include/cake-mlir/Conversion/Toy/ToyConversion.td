#ifndef TOY_TO_STANDARD
#define TOY_TO_STANDARD

include "mlir/Pass/PassBase.td"

def ToyToStandard : Pass<"toy-to-standard"> {
    let summary = "Lower `toy` to standard MLIR dialects.";
  
    let description = [{
        This pass lowers the `toy` dialect to standard MLIR, a mixture of affine,
        tensor, and arith.
    }];
    let dependentDialects = [
        "mlir::func::FuncDialect",
        "mlir::toy::ToyDialect",
        "mlir::affine::AffineDialect",
        "mlir::memref::MemRefDialect",
    ];
}

def ToyToLLVM : Pass<"toy-to-llvm"> {
    let summary = "Lower `toy` to llvm MLIR dialects.";
  
    let description = [{
        This pass lowers the `toy` dialect to llvm MLIR, a mixture of affine,
        tensor, and arith.
    }];
    let dependentDialects = [
        "mlir::LLVM::LLVMDialect",
        "mlir::scf::SCFDialect",
    ];
}

#endif // TOY_TO_STANDARD