#include "mlir/IR/MLIRContext.h"
#include "mlir/Support/FileUtilities.h"
#include "mlir/Tools/mlir-opt/MlirOptMain.h"
#include "mlir/Transforms/Passes.h"

#include "cake-mlir/InitAll.h"

#ifdef CAKE_MLIR_ENABLE_STABLEHLO
#include "stablehlo/dialect/Register.h"
#endif

int main(int argc, char **argv) {
  mlir::DialectRegistry registry;



#ifdef CAKE_MLIR_ENABLE_STABLEHLO
  mlir::stablehlo::registerAllDialects(registry);
#endif
  mlir::cake::registerAllDialects(registry);
  mlir::cake::registerOptionalInputDialects(registry);
  mlir::cake::registerAllExtensions(registry);
  mlir::cake::registerAllPasses();
  

  return mlir::asMainReturnCode(
      mlir::MlirOptMain(argc, argv, "Cake optimizer driver\n", registry));
}