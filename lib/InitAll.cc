#include "cake-mlir/InitAll.h"
#include "cake-mlir/Dialect/Cake/CakeDialect.h"

#ifdef CAKE_MLIR_ENABLE_STABLEHLO
#include "stablehlo/conversions/linalg/transforms/Passes.h"
#include "stablehlo/transforms/Passes.h"
#endif

#ifdef CAKE_MLIR_ENABLE_TORCH_MLIR
#include "torch-mlir/InitAll.h"
#endif

#include "mlir/Dialect/Math/IR/Math.h"
#include "mlir/Dialect/Tosa/IR/TosaOps.h"

#include "mlir/Conversion/Passes.h"
#include "mlir/InitAllPasses.h"

namespace mlir {
namespace cake {

void registerAllDialects(mlir::DialectRegistry &registry) {
    registry.insert<CakeDialect>();
#ifdef CAKE_MLIR_ENABLE_TORCH_MLIR
    mlir::torch::registerAllDialects(registry);
#endif
}

void registerAllExtensions(mlir::DialectRegistry &registry) {
#ifdef CAKE_MLIR_ENABLE_TORCH_MLIR
    mlir::torch::registerAllExtensions(registry);
#endif
}

void registerOptionalInputDialects(mlir::DialectRegistry &registry) {
    registry.insert<
        mlir::math::MathDialect,
        mlir::tosa::TosaDialect
    >();
#ifdef CAKE_MLIR_ENABLE_TORCH_MLIR
    mlir::torch::registerOptionalInputDialects(registry);
#endif 
}

void registerAllPasses() {
    
    mlir::registerAllPasses();

#ifdef CAKE_MLIR_ENABLE_TORCH_MLIR
    mlir::torch::registerAllPasses();
#endif 

#ifdef CAKE_MLIR_ENABLE_STABLEHLO
  mlir::stablehlo::registerStablehloLegalizeToLinalgPass();
  mlir::stablehlo::registerStablehloAggressiveSimplificationPass();
  mlir::stablehlo::registerStablehloRefineShapesPass();
  mlir::stablehlo::registerStablehloConvertToSignlessPass();
  mlir::stablehlo::registerShapeLegalizeToStablehloPass();
  mlir::stablehlo::registerStablehloLegalizeDeprecatedOpsPass();
#endif
}

} // namespace cake
} // namespace mlir