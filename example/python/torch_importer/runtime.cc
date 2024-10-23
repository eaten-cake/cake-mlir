#include <cstdlib>
#include <iostream>

struct MemRef {
    float* allocated;
    float* aligned;
    int64_t offset;
    int64_t shape[4];
    int64_t strides[4];
};

extern "C" void _mlir_ciface_forward(MemRef* output, MemRef* input);

int main() {

    std::cout << "Hello, World!" << "\n";
    int n = 1;
    int c = 3;
    int h = 224;
    int w = 224;

    

    return 0;
}




