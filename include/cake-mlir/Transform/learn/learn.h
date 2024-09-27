#include "mlir/Pass/Pass.h"

namespace mlir {
namespace cake {

// generate the declaration of all the passes
#define GEN_PASS_DECL
#include "cake-mlir/Transform/learn/LearnPass.h.inc"

// generate the registration of all the passes
#define GEN_PASS_REGISTRATION
#include "cake-mlir/Transform/learn/LearnPass.h.inc"

} // namespace cake
} // namespace mlir