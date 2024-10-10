#include "cake-mlir/Conversion/Toy/ToyToStandard.h"

namespace mlir {
namespace toy{

#define GEN_PASS_DEF_TOYTOSTANDARD
#include "cake-mlir/Conversion/Toy/ToyToStandard.h.inc"



struct ToyToStandard : impl::ToyToStandardBase<ToyToStandard> {
    using ToyToStandardBase::ToyToStandardBase;

    void runOnOperation() override {

    }
};

} // namespace toy
} // namespace mlir