#include "mlir/Bindings/Python/PybindAdaptors.h"

#include "cake-mlir-c/tensor.h"

namespace py = pybind11;

using namespace mlir;
using namespace mlir::python;

class PyTensor {
public:
    PyTensor(CakeTensor tensor) : tensor(tensor) {}
private:
    CakeTensor tensor;
};

// PYBIND11_MODULE(_cakeMlirRuntime, m) {
//     m.doc() = "Python bindings for the cake-mlir runtime";

//     py::class_<PyTensor>(m, "Tensor", py::buffer_protocol())
//         .def(py::init<>(
//             [] (int32_t ndim, std::vector<int64_t> shape, std::string dtype) {
//                 CakeTensor tensor = cakeTensorCreate(ndim, shape.data(), );
//             }
//         ))
// }