#include <llvm/Support/raw_ostream.h>

#include <mlir/IR/MLIRContext.h>
#include <mlir/InitAllDialects.h>
#include <mlir/InitAllPasses.h>
#include <mlir/Pass/PassManager.h>

using namespace mlir;

int main() {

    auto context = mlir::MLIRContext();
    mlir::DialectRegistry registry;
    mlir::registerAllDialects(registry);
    mlir::registerAllPasses();
    context.appendDialectRegistry(registry);
    context.loadAllAvailableDialects();

    auto builder = OpBuilder(&context);

    auto ptr_type = LLVM::LLVMPointerType::get(&context);

    // auto llvm_func = builder.create<LLVM::LLVMFuncOp>("test", mlir::FunctionType::get(&context, TypeRange({ptr_type}), TypeRange({ptr_type})));

    // llvm::outs() << llvm_func << "\n";

    return 0;
}