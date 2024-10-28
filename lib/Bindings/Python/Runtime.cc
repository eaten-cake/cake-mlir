#include "mlir/Bindings/Python/PybindAdaptors.h"

namespace py = pybind11;

using namespace mlir;
using namespace mlir::python;

PYBIND11_MODULE(_cakeMlirRuntime, m) {
    m.doc() = "Python bindings for the cake-mlir runtime";

    
}