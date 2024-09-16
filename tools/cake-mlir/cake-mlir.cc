#include <llvm/Support/raw_ostream.h>

#include <mlir/IR/MLIRContext.h>
#include <mlir/InitAllDialects.h>
#include <mlir/InitAllPasses.h>
#include <mlir/Pass/PassManager.h>

using namespace mlir;

int main() {

    MLIRContext context;
    auto builder = OpBuilder(&context);
    registerAllDialects(context);
    context.loadAllAvailableDialects();

    auto mod = builder.create<ModuleOp>(builder.getUnknownLoc());

    builder.setInsertionPointToEnd(mod.getBody());

    auto TensorType = RankedTensorType::get({1, 2048, 2048}, builder.getF32Type());
    auto funcType = builder.getFunctionType({TensorType, TensorType}, {TensorType});
    auto func = builder.create<func::FuncOp>(builder.getUnknownLoc(), "tosa_matmul", funcType);

    auto entry = func.addEntryBlock();
    auto args = entry->getArguments();

    builder.setInsertionPointToEnd(entry);

    auto tosa_matmul = builder.create<tosa::MatMulOp>(builder.getUnknownLoc(), TensorType, args[0], args[1]);
    builder.create<func::ReturnOp>(builder.getUnknownLoc(), ValueRange({tosa_matmul}));

    mod->print(llvm::outs());

    return 0;
}