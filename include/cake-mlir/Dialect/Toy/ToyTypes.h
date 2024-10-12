#ifndef CAKE_MLIR_DIALECT_TOY_TOYTYPES_H_
#define CAKE_MLIR_DIALECT_TOY_TOYTYPES_H_

// Required because the .h.inc file refers to MLIR classes and does not itself
// have any includes.
#include "mlir/IR/DialectImplementation.h"

#define GET_TYPEDEF_CLASSES
#include "cake-mlir/Dialect/Toy/ToyTypes.h.inc"

#endif // CAKE_MLIR_DIALECT_TOY_TOYTYPES_H_