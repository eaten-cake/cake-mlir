#include "cake-mlir/runtime/tensor.h"

#include <cstring>

namespace cake {
namespace runtime {

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