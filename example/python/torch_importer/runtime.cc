#include <cstdlib>
#include <iostream>
#include <vector>
#include <initializer_list>
#include <cstring>

#include "cake-mlir/runtime/tensor.h"

extern "C" void _mlir_ciface_forward(Tensor<float, 4> *output, Tensor<float, 4> *input);

extern "C" void memrefCopy(int64_t elemSize, Tensor<float, 1> *src, Tensor<float, 1> *dst) {
    float* srcData = src->getData() + src->getOffset() * elemSize;
    float* dstData = dst->getData() + dst->getOffset() * elemSize;

    std::cout << elemSize << "\n";

    // memcpy(dstData, srcData, elemSize);

    // for(int i = 0; i < 2; i++) {
    //     dst->strides[i] = src->strides[i];
    //     dst->shape[i] = src->shape[i];
    // }

    

    exit(0);

    // std::cout << "memrefCopy called\n";

    // exit(0);

}

int main() {

    Tensor<float, 4> input({1, 3, 64, 64});
    Tensor<float, 4> output({1, 3, 32, 32});

    _mlir_ciface_forward(&output, &input);

    std::cout << "output:\n";
    for(int i = 0; i < 10; i++) {
        std::cout << output.getData()[i] << " ";
    }

    std::cout << "\n";



    return 0;
}




