#ifndef CAKE_MLIR_RUNTIME_TENSOR_H_
#define CAKE_MLIR_RUNTIME_TENSOR_H_

#include <cstdlib>
#include <initializer_list>
#include <vector>
#include <stdexcept>

#include "types.h"

namespace cake {
namespace runtime {
// https://github.com/llvm/llvm-project/blob/08220df62a19b0136924a3e3e48d207cf3e0666c/mlir/lib/Conversion/LLVMCommon/TypeConverter.cpp#L292
template <typename T, int N>
class Tensor {
public:
    Tensor() {}

    Tensor(std::vector<int64_t> shape) {
        int shape_size = shape.size();
        if(shape_size != N) throw std::runtime_error("Invalid shape size");
        int64_t total_size = 1;
        for (int i = 0; i < shape_size; i++) {
            this->shape[i] = shape[i];
            total_size *= shape[i];
        }
        allocated = (T*)malloc(total_size * sizeof(T));
        aligned = allocated;
        offset = 0;
        strides[shape_size - 1] = 1;
        for(int i = shape_size - 2; i >= 0; i--) {
            strides[i] = strides[i + 1] * shape[i + 1];
        }
    }

    template <typename IterType>
    Tensor(IterType begin, IterType end) : Tensor(std::vector<int64_t>(begin, end)) {}

    Tensor(std::initializer_list<int64_t> shape) : Tensor(std::vector<int64_t>(shape)) {}

    T* getData() {
        return aligned;
    }

    int64_t getOffset() {
        return offset;
    }

    std::vector<int64_t> getShape() {
        return std::vector<int64_t>(shape, shape + N);
    }

    ~Tensor() {
        if(allocated) free(allocated);
        allocated = nullptr;
        aligned = nullptr;
        offset = 0;
        // free(shape);
        // free(strides);
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

class NDArray {
public:
    NDArray() = default;

    NDArray(std::vector<int64_t> shape, DataType dtype, void *dataPtr);

    ~NDArray() {
        if(_basePtr) {
            free(_basePtr);
        }
    }

    void *getBasePtr() { return _basePtr; }
    void *getDataPtr() { return _data; }
    int64_t getOffset() { return _offset; }
    int64_t *getShapePtr() { return _shape; }
    int64_t *getStridesPtr() { return _strides; }
    int64_t getRank() { return _rank; }
    DataType getDataType() { return _dtype; }

private:
    void *_basePtr = nullptr;
    void *_data = nullptr;
    int64_t _offset;
    int64_t *_shape;
    int64_t *_strides;
    int64_t _rank;
    DataType _dtype;
};

using ListNDArray = NDArray *;

extern "C" void *getBasePtrByIndex(ListNDArray list, int index);

extern "C" void *getDataPtrByIndex(ListNDArray list, int index);

extern "C" int64_t getOffsetByIndex(ListNDArray list, int index);

extern "C" int64_t getRankByIndex(ListNDArray list, int index);

extern "C" int64_t *getShapeByIndex(ListNDArray list, int index);

extern "C" int64_t *getStridesByIndex(ListNDArray list, int index);

extern "C" void memrefCopy(int64_t elemSize, UnrankedTensor<char> *srcArg, UnrankedTensor<char> *dstArg);

} // namespace runtime
} // namespace cake

#endif // CAKE_MLIR_RUNTIME_TENSOR_H_