#include "cake-mlir-c/tensor.h"

#include "dlpack/dlpack.h"

#include <cstdlib>
#include <initializer_list>

extern "C" CakeTensor cakeTensorCreate(int32_t ndim, int64_t* shape, DLDataType type) {
    CakeTensor tensor;
    // tensor.ptr = new cake::runtime::Tensor<float, ndim>(shape, shape + ndim);
    DLTensor* dl_tensor = new DLTensor;

    dl_tensor->ndim = ndim;
    dl_tensor->byte_offset = 0;
    dl_tensor->shape = shape;
    dl_tensor->dtype = type;
    dl_tensor->strides = new int64_t[ndim];
    int64_t size = 1;
    for (int i = ndim - 1; i >= 0; i--) {
        dl_tensor->strides[i] = size;
        size *= shape[i];
    }
    dl_tensor->data = malloc(size * (type.bits + type.lanes + 7) / 8);
    dl_tensor->device = DLDevice{kDLCPU, 0};

    tensor.ptr = dl_tensor;
    return tensor;
}

extern "C" void cakeTensorDestroy(CakeTensor tensor) {
    DLTensor* dl_tensor = static_cast<DLTensor*>(tensor.ptr);
    free(dl_tensor->data);
    delete[] dl_tensor->strides;
    delete dl_tensor;
}