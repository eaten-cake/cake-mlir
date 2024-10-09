#ifndef CAKE_MLIR_DIALECT_TOY_TOYOPS_H_
#define CAKE_MLIR_DIALECT_TOY_TOYOPS_H_

#include "mlir/Bytecode/BytecodeOpInterface.h"
#include "mlir/IR/Dialect.h"
#include "mlir/IR/SymbolTable.h"
#include "mlir/Interfaces/CallInterfaces.h"
#include "mlir/Interfaces/CastInterfaces.h"
#include "mlir/Interfaces/FunctionInterfaces.h"
#include "mlir/Interfaces/SideEffectInterfaces.h"
#include "mlir/IR/OpDefinition.h"

#define GET_OP_CLASSES
#include "cake-mlir/Dialect/Toy/ToyOps.h.inc"

#endif // CAKE_MLIR_DIALECT_TOY_TOYOPS_H_