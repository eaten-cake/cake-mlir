#include "mlir/IR/DialectRegistry.h"
#include "mlir/IR/Operation.h"
#include "mlir/InitAllTranslations.h"
#include "mlir/Tools/mlir-translate/MlirTranslateMain.h"
#include "mlir/Tools/mlir-translate/Translation.h"
#include "llvm/Support/raw_ostream.h"

int main(int argc, char **argv) {
  mlir::registerAllTranslations();

  // TODO: Register standalone translations here.
  mlir::TranslateFromMLIRRegistration withdescription(
      "option", "different from option",
      [](mlir::Operation *op, llvm::raw_ostream &output) {
        return llvm::LogicalResult::success();
      },
      [](mlir::DialectRegistry &a) {});

  return failed(
      mlir::mlirTranslateMain(argc, argv, "Cake-MLIR Translation Tool"));
}