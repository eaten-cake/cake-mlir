#ifndef CAKE_MLIR_TRANSFORM_TOY_PASSES_H_
#define CAKE_MLIR_TRANSFORM_TOY_PASSES_H_

#include "mlir/Pass/Pass.h"

#include "cake-mlir/Dialect/Toy/ToyDialect.h"

namespace mlir {
namespace toy {

#define GEN_PASS_DECL
#include "cake-mlir/Transform/Toy/Passes.h.inc"

#define GEN_PASS_REGISTRATION
#include "cake-mlir/Transform/Toy/Passes.h.inc"

} // namespace toy
} // namespace mlir

#endif // CAKE_MLIR_TRANSFORM_TOY_PASSES_H_