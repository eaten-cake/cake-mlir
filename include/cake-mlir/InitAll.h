#ifndef CAKE_MLIR_INITALL_H_
#define CAKE_MLIR_INITALL_H_

#include "mlir/IR/Dialect.h"

namespace mlir {
namespace cake {

// Registers all dialects that this project produces and any dependencies.
void registerAllDialects(mlir::DialectRegistry &registry);

// Registers all necessary dialect extensions for this project
void registerAllExtensions(mlir::DialectRegistry &registry);

// Registers dialects that may be needed to parse torch-mlir inputs and
// test cases.
void registerOptionalInputDialects(mlir::DialectRegistry &registry);

void registerAllPasses();

} // namespace cake
} // namespace mlir

#endif // CAKE_MLIR_INITALL_H_