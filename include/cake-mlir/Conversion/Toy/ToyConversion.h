#ifndef CAKE_MLIR_CONVERSION_TOY_TOYCONVERSION_H_
#define CAKE_MLIR_CONVERSION_TOY_TOYCONVERSION_H_

#include "mlir/Pass/Pass.h"

#include "mlir/Dialect/LLVMIR/LLVMDialect.h"

namespace mlir {
namespace toy {

#define GEN_PASS_DECL
#include "cake-mlir/Conversion/Toy/ToyConversion.h.inc"

#define GEN_PASS_REGISTRATION
#include "cake-mlir/Conversion/Toy/ToyConversion.h.inc"

} // namespace toy
} // namespace mlir

#endif // CAKE_MLIR_CONVERSION_TOY_TOYCONVERSION_H_