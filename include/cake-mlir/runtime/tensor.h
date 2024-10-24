#ifndef CAKE_MLIR_RUNTIME_TENSOR_H_
#define CAKE_MLIR_RUNTIME_TENSOR_H_

#include <cstdlib>
#include <initializer_list>

template <typename dtype, int N>
class Tensor {
public:
    Tensor() {}
    Tensor(std::initializer_list<int64_t> shape) {
        
    }


private:
    dtype *allocated;
    dtype *aligned;
    int64_t offset;
    int64_t shape[N];
    int64_t strides[N];
};

#endif // CAKE_MLIR_RUNTIME_TENSOR_H_