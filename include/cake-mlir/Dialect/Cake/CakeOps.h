#ifndef CAKE_MLIR_DIALECT_CAKE_CAKEOPS_H_
#define CAKE_MLIR_DIALECT_CAKE_CAKEOPS_H_

#include "mlir/IR/BuiltinTypes.h"
#include "mlir/IR/Dialect.h"
#include "mlir/IR/OpDefinition.h"
#include "mlir/Interfaces/InferTypeOpInterface.h"
#include "mlir/Interfaces/SideEffectInterfaces.h"

#define GET_OP_CLASSES
#include "cake-mlir/Dialect/Cake/CakeOps.h.inc"

#endif // CAKE_MLIR_DIALECT_CAKE_CAKEOPS_H_