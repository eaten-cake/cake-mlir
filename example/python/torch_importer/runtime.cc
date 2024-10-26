#include <cstdlib>
#include <iostream>
#include <vector>
#include <initializer_list>
#include <cstring>
#include <functional>

#include <dlfcn.h>

#include "cake-mlir/runtime/tensor.h"
#include "cake-mlir/runtime/module.h"

using namespace cake::runtime;

int main() {

    Tensor<float, 4> input({1, 3, 64, 64});
    Tensor<float, 4> output({1, 3, 32, 32});

    // _mlir_ciface_forward(&output, &input);

    void* handle = dlopen("../libmodel.so", RTLD_LAZY);
    if (!handle) {
        std::cerr << "Could not load library: " << dlerror() << std::endl;
        return 1;
    }

    auto func = load_function<void, Tensor<float, 4>*, Tensor<float, 4>*>(handle, "_mlir_ciface___cake_forward__");
    func(&output, &input);

    std::cout << "output:\n";
    for(int i = 0; i < 10; i++) {
        std::cout << output.getData()[i] << " ";
    }

    std::cout << "\n";



    return 0;
}




