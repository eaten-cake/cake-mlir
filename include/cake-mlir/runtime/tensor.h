#ifndef CAKE_MLIR_RUNTIME_TENSOR_H_
#define CAKE_MLIR_RUNTIME_TENSOR_H_

#include <cstdlib>
#include <initializer_list>
#include <vector>
#include <stdexcept>

// #include "dlpack/dlpack.h"

template <typename dtype, int N>
class Tensor {
public:
    Tensor() {}
    Tensor(std::initializer_list<int64_t> shape) {
        std::vector<int64_t> shape_vec(shape);
        int shape_size = shape.size();
        if(shape_size != N) throw std::runtime_error("Invalid shape size");
        int64_t total_size = 1;
        for (int i = 0; i < shape_size; i++) {
            this->shape[i] = shape_vec[i];
            total_size *= shape_vec[i];
        }
        allocated = (dtype*)malloc(total_size * sizeof(dtype));
        aligned = allocated;
        offset = 0;
        strides[shape_size - 1] = 1;
        for(int i = shape_size - 2; i >= 0; i--) {
            strides[i] = strides[i + 1] * shape_vec[i + 1];
        }
    }
    dtype* getData() {
        return aligned;
    }
    int64_t getOffset() {
        return offset;
    }

    dtype *allocated;
    dtype *aligned;
    int64_t offset;
    int64_t shape[N];
    int64_t strides[N];
};

template <typename dtype>
class UnrankedTensor {
    int64_t rank;
    void* descriptor;
}

#endif // CAKE_MLIR_RUNTIME_TENSOR_H_