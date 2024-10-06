#include "cake-mlir/Dialect/Toy/ToyDialect.h"
#include "cake-mlir/Dialect/Toy/ToyOps.h"

#include "cake-mlir/Dialect/Toy/ToyDialect.cpp.inc"
#define GET_OP_CLASSES
#include "cake-mlir/Dialect/Toy/ToyOps.cpp.inc"

namespace mlir {
namespace toy {

void ToyDialect::initialize() {
    addOperations<
#define GET_OP_LIST
#include "cake-mlir/Dialect/Toy/ToyOps.cpp.inc"
    >();
}

} // namespace toy
} // namespace mlir