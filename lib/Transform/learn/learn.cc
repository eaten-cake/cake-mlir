#define GEN_PASS_DEF_LEARNPASS
#include "cake-mlir/Transform/learn/learn.h"

namespace mlir {
namespace cake {

void printOperation(Operation *op);

  void printBlock(Block &block) {
    // Print the block intrinsics properties (basically: argument list)
    llvm::outs()
        << "Block with " << block.getNumArguments() << " arguments, "
        << block.getNumSuccessors()
        << " successors, and "
        // Note, this `.size()` is traversing a linked-list and is O(n).
        << block.getOperations().size() << " operations\n";

    // A block main role is to hold a list of Operations: let's recurse into
    // printing each operation.
    for (Operation &op : block.getOperations())
      printOperation(&op);
  }

  void printRegion(Region &region) {
    // A region does not hold anything by itself other than a list of blocks.
    llvm::outs() << "Region with " << region.getBlocks().size()
                  << " blocks:\n";
    for (Block &block : region.getBlocks())
      printBlock(block);
  }

void printOperation(Operation *op) {
    // Print the operation itself and some of its properties
    llvm::outs() << "visiting op: '" << op->getName() << "' with "
                  << op->getNumOperands() << " operands and "
                  << op->getNumResults() << " results\n";
    // Print the operation attributes
    if (!op->getAttrs().empty()) {
      llvm::outs() << op->getAttrs().size() << " attributes:\n";
      for (NamedAttribute attr : op->getAttrs())
        llvm::outs() << " - '" << attr.getName() << "' : '"
                      << attr.getValue() << "'\n";
    }

    // Recurse into each of the regions attached to the operation.
    llvm::outs() << " " << op->getNumRegions() << " nested regions:\n";
    for (Region &region : op->getRegions())
      printRegion(region);
  }

struct LearnPass : 
    impl::LearnPassBase<LearnPass> 
{
    using LearnPassBase::LearnPassBase;

    void runOnOperation() override {
        Operation* op = getOperation();
        printOperation(op);
    }
};

} // namespace cake
} // namespace mlir