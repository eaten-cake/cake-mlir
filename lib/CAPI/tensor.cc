#include "cake-mlir-c/tensor.h"

#include "cake-mlir/Runtime/tensor.h"

#include <initializer_list>

extern "C" CakeTensor cakeTensorCreate(int ndim, int64_t* shape) {
    CakeTensor tensor;
    // tensor.ptr = new cake::runtime::Tensor<float, ndim>(shape, shape + ndim);

}