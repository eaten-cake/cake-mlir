#ifndef CAKE_MLIR_RUNTIME_TENSOR_H_
#define CAKE_MLIR_RUNTIME_TENSOR_H_

#include <cstdlib>
#include <initializer_list>
#include <vector>
#include <stdexcept>

// #include "dlpack/dlpack.h"
namespace cake {
namespace runtime {
// https://github.com/llvm/llvm-project/blob/08220df62a19b0136924a3e3e48d207cf3e0666c/mlir/lib/Conversion/LLVMCommon/TypeConverter.cpp#L292
template <typename T, int N>
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
        allocated = (T*)malloc(total_size * sizeof(T));
        aligned = allocated;
        offset = 0;
        strides[shape_size - 1] = 1;
        for(int i = shape_size - 2; i >= 0; i--) {
            strides[i] = strides[i + 1] * shape_vec[i + 1];
        }
    }
    T* getData() {
        return aligned;
    }
    int64_t getOffset() {
        return offset;
    }

    T *allocated;
    T *aligned;
    int64_t offset;
    int64_t shape[N];
    int64_t strides[N];
};

template <typename T>
class UnrankedTensor {
public:
    int64_t rank;
    void* descriptor;
};

template <typename T>
class DynamicTensor {
public:
    int64_t rank;
    T* allocated;
    T* aligned;
    int64_t offset;
    int64_t *shape;
    int64_t *strides;
    
    explicit DynamicTensor(UnrankedTensor<T>& tensor) {
        rank = tensor.rank;
        auto *desc = static_cast<Tensor<T, 1> *>(tensor.descriptor);
        allocated = desc->allocated;
        aligned = desc->aligned;
        offset = desc->offset;
        shape = rank == 0 ? nullptr : desc->shape;
        strides = shape + rank;
    }
};

extern "C" void memrefCopy(int64_t elemSize, UnrankedTensor<char> *srcArg, UnrankedTensor<char> *dstArg);

} // namespace runtime
} // namespace cake

#endif // CAKE_MLIR_RUNTIME_TENSOR_H_