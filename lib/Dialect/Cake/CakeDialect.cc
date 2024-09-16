#include "cake-mlir/Dialect/Cake/CakeDialect.h"
#include "cake-mlir/Dialect/Cake/CakeOps.h"

#include "cake-mlir/Dialect/Cake/CakeDialect.cpp.inc"
#define GET_OP_CLASSES
#include "cake-mlir/Dialect/Cake/CakeOps.cpp.inc"

namespace mlir {
namespace cake {

//===----------------------------------------------------------------------===//
// Cake dialect.
//===----------------------------------------------------------------------===//

void CakeDialect::initialize() {
//     addTypes<
// #define GET_TYPEDEF_LIST
// #include "lib/Dialect/Poly/PolyTypes.cpp.inc"
//       >();

    addOperations<
#define GET_OP_LIST
#include "cake-mlir/Dialect/Cake/CakeOps.cpp.inc"
      >();
}

}
} // namespace mlir