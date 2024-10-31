#include <cstdlib>
#include <iostream>
#include <vector>
#include <initializer_list>
#include <cstring>
#include <functional>

#include <dlfcn.h>

#include "cake-mlir/Runtime/tensor.h"
#include "cake-mlir/Runtime/module.h"

using namespace cake::runtime;

int main() {

    // Tensor<float, 4> input({1, 3, 64, 64});
    // Tensor<float, 4> output({1, 3, 32, 32});
    float *input_data = new float[1*3*64*64];
    float *output_data = new float[1*3*32*32];
    NDArray input({1, 3, 64, 64}, {kFloat, 32, 1}, input_data);
    NDArray output({1, 3, 32, 32}, {kFloat, 32, 1}, output_data);

    void* handle = dlopen("../libmodel.so", RTLD_LAZY);
    if (!handle) {
        std::cerr << "Could not load library: " << dlerror() << std::endl;
        return 1;
    }

    auto func = load_function<void, NDArray *, NDArray *>(handle, "_mlir_ciface_cake_run");

    func(&output, &input);



    std::cout << "output:\n";
    for(int i = 0; i < 10; i++) {
        std::cout << ((float *)(output._data))[i] << " ";
    }

    std::cout << "\n";



    return 0;
}




