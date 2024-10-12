#include "cake-mlir/Dialect/Toy/ToyDialect.h"
#include "cake-mlir/Dialect/Toy/ToyOps.h"
#include "cake-mlir/Dialect/Toy/ToyTypes.h"

#include "llvm/ADT/TypeSwitch.h"
#include "llvm/ADT/ArrayRef.h"
#include "mlir/IR/Builders.h"

#include "cake-mlir/Dialect/Toy/ToyDialect.cpp.inc"
#define GET_OP_CLASSES
#include "cake-mlir/Dialect/Toy/ToyOps.cpp.inc"
#define GET_TYPEDEF_CLASSES
#include "cake-mlir/Dialect/Toy/ToyTypes.cpp.inc"

namespace mlir {
namespace toy {

//===----------------------------------------------------------------------===//
// ToyInlinerInterface
//===----------------------------------------------------------------------===//

/// This class defines the interface for handling inlining with Toy
/// operations.
struct ToyInlinerInterface : public DialectInlinerInterface {
  using DialectInlinerInterface::DialectInlinerInterface;

  //===--------------------------------------------------------------------===//
  // Analysis Hooks
  //===--------------------------------------------------------------------===//

  /// All call operations within toy can be inlined.
  bool isLegalToInline(Operation *call, Operation *callable,
                       bool wouldBeCloned) const final {
    return true;
  }

  /// All operations within toy can be inlined.
  bool isLegalToInline(Operation *, Region *, bool, IRMapping &) const final {
    return true;
  }

  // All functions within toy can be inlined.
  bool isLegalToInline(Region *, Region *, bool, IRMapping &) const final {
    return true;
  }

  //===--------------------------------------------------------------------===//
  // Transformation Hooks
  //===--------------------------------------------------------------------===//

  /// Handle the given inlined terminator(toy.return) by replacing it with a new
  /// operation as necessary.
  void handleTerminator(Operation *op, ValueRange valuesToRepl) const final {
    // Only "toy.return" needs to be handled here.
    auto returnOp = cast<ReturnOp>(op);

    // Replace the values directly with the return operands.
    assert(returnOp.getNumOperands() == valuesToRepl.size());
    for (const auto &it : llvm::enumerate(returnOp.getOperands()))
      valuesToRepl[it.index()].replaceAllUsesWith(it.value());
  }

  /// Attempts to materialize a conversion for a type mismatch between a call
  /// from this dialect, and a callable region. This method should generate an
  /// operation that takes 'input' as the only operand, and produces a single
  /// result of 'resultType'. If a conversion can not be generated, nullptr
  /// should be returned.
  Operation *materializeCallConversion(OpBuilder &builder, Value input,
                                       Type resultType,
                                       Location conversionLoc) const final {
    return builder.create<CastOp>(conversionLoc, resultType, input);
  }
};

void ToyDialect::initialize() {

    addTypes<
#define GET_TYPEDEF_LIST
#include "cake-mlir/Dialect/Toy/ToyTypes.cpp.inc"
    >();

    addOperations<
#define GET_OP_LIST
#include "cake-mlir/Dialect/Toy/ToyOps.cpp.inc"
    >();
    addInterfaces<ToyInlinerInterface>();
}

} // namespace toy
} // namespace mlir