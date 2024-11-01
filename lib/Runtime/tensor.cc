#include "cake-mlir/Runtime/tensor.h"

#include <cstring>
#include <iostream>

namespace cake {
namespace runtime {

NDArray::NDArray(std::vector<int64_t> shape, DataType dtype, void *dataPtr) {
    int64_t _rank = shape.size();
    // _shape.resize(_rank);
    _shape = (int64_t *)malloc(sizeof(int64_t) * _rank);
    std::copy(shape.begin(), shape.end(), _shape);
    _dtype = dtype;
    _basePtr = dataPtr;
    _data = dataPtr;
    _offset = 0;
    // _strides.resize(_rank);
    _strides = (int64_t *)malloc(sizeof(int64_t) * _rank);
    _strides[_rank - 1] = 1;
    for(int i = _rank - 2; i >= 0; --i) {
        _strides[i] = _strides[i + 1] * _shape[i + 1];
    }
}

extern "C" void *getBasePtrByIndex(ListNDArray list, int index) {
    return list[index].getBasePtr();
}

extern "C" void *getDataPtrByIndex(ListNDArray list, int index) {
    return list[index].getDataPtr();
}

extern "C" int64_t getOffsetByIndex(ListNDArray list, int index) {
    return list[index].getOffset();
}

extern "C" int64_t getRankByIndex(ListNDArray list, int index) {
    return list[index].getRank();
}

extern "C" int64_t *getShapeByIndex(ListNDArray list, int index) {
    return list[index].getShapePtr();
}

extern "C" int64_t *getStridesByIndex(ListNDArray list, int index) {
    return list[index].getStridesPtr();
}

extern "C" void memrefCopy(int64_t elemSize, UnrankedTensor<char> *srcArg, UnrankedTensor<char> *dstArg) {
    
    DynamicTensor<char> src(*srcArg);
    DynamicTensor<char> dst(*dstArg);

    int64_t rank = src.rank;

    // Handle empty shapes -> nothing to copy.
    for (int rankp = 0; rankp < rank; ++rankp)
        if (src.shape[rankp] == 0)
        return;

    char *srcPtr = src.aligned + src.offset * elemSize;
    char *dstPtr = dst.aligned + dst.offset * elemSize;

    if (rank == 0) {
        memcpy(dstPtr, srcPtr, elemSize);
        return;
    }

    int64_t *indices = static_cast<int64_t *>(alloca(sizeof(int64_t) * rank));
    int64_t *srcStrides = static_cast<int64_t *>(alloca(sizeof(int64_t) * rank));
    int64_t *dstStrides = static_cast<int64_t *>(alloca(sizeof(int64_t) * rank));

    // Initialize index and scale strides.
    for (int rankp = 0; rankp < rank; ++rankp) {
        indices[rankp] = 0;
        srcStrides[rankp] = src.strides[rankp] * elemSize;
        dstStrides[rankp] = dst.strides[rankp] * elemSize;
    }

    int64_t readIndex = 0, writeIndex = 0;
    for (;;) {
        // Copy over the element, byte by byte.
        memcpy(dstPtr + writeIndex, srcPtr + readIndex, elemSize);
        // Advance index and read position.
        for (int64_t axis = rank - 1; axis >= 0; --axis) {
            // Advance at current axis.
            auto newIndex = ++indices[axis];
            readIndex += srcStrides[axis];
            writeIndex += dstStrides[axis];
            // If this is a valid index, we have our next index, so continue copying.
            if (src.shape[axis] != newIndex)
                break;
            // We reached the end of this axis. If this is axis 0, we are done.
            if (axis == 0)
                return;
            // Else, reset to 0 and undo the advancement of the linear index that
            // this axis had. Then continue with the axis one outer.
            indices[axis] = 0;
            readIndex -= src.shape[axis] * srcStrides[axis];
            writeIndex -= dst.shape[axis] * dstStrides[axis];
        }
    }

}

} // namespace runtime
} // namespace cake