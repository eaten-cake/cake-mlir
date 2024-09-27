#define GEN_PASS_DEF_LEARNPASS
#include "cake-mlir/Transform/learn/learn.h"

namespace mlir {
namespace cake {

struct LearnPass : 
    impl::LearnPassBase<LearnPass> 
{
    using LearnPassBase::LearnPassBase;

    void runOnOperation() override {
        
    }
};

} // namespace cake
} // namespace mlir