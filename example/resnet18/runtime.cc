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

    Tensor<float, 4> input({1, 3, 224, 224});
    Tensor<float, 2> output({1, 1000});

    void* handle = dlopen("../model.so", RTLD_NOW);
    if (!handle) {
        std::cerr << "Could not load library: " << dlerror() << std::endl;
        return 1;
    }

    auto func = load_function<void, Tensor<float, 2>*, Tensor<float, 4>*>(handle, "_mlir_ciface_cake_run");
    func(&output, &input);

    std::cout << "output:\n";
    for(int i = 0; i < 10; i++) {
        std::cout << output.getData()[i] << " ";
    }

    std::cout << "\n";



    return 0;
}




