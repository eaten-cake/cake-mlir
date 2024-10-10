#ifndef CAKE_MLIR_CONVERSION_TOY_TOYTOSTANDARD_H_
#define CAKE_MLIR_CONVERSION_TOY_TOYTOSTANDARD_H_

#include "mlir/Pass/Pass.h"

namespace mlir {
namespace toy {

#define GEN_PASS_DECL
#include "cake-mlir/Conversion/Toy/ToyToStandard.h.inc"

#define GEN_PASS_REGISTRATION
#include "cake-mlir/Conversion/Toy/ToyToStandard.h.inc"

} // namespace toy
} // namespace mlir

#endif // CAKE_MLIR_CONVERSION_TOY_TOYTOSTANDARD_H_