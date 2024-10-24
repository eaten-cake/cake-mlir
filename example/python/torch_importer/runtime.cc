#include <cstdlib>
#include <iostream>
#include <vector>
#include <initializer_list>

#include "cake-mlir/runtime/tensor.h"

extern "C" void _mlir_ciface_forward(Tensor<float, 4> *output, Tensor<float, 4> *input);

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




