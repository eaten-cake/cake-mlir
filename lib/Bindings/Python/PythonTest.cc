#include "mlir/Bindings/Python/PybindAdaptors.h"

namespace py = pybind11;
using namespace mlir;
using namespace mlir::python;

class TestAdd {
public:
    TestAdd(int a, int b) : a(a), b(b) {}
    int add() {
        return a + b;
    }
private:
    int a, b;
};

PYBIND11_MODULE(_cakePythonTest, m) {
    m.doc() = "Cake MLIR PythonTest";

    py::class_<TestAdd>(m, "TestAdd", py::module_local())
        .def(py::init<>([] (int a, int b) {
                return new TestAdd(a, b);
            }),
            py::arg("a"), py::arg("b"),
            "return a + b;")
        .def(
            "add",
            [] (TestAdd &testAdd) {
                return testAdd.add();
            },
            "call TestAdd.add()"
        );

}

