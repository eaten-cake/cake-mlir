#include <cstdlib>

template <typename T, int N>
class MemRef {
public:
    T* allocated;
    T* aligned;
    int64_t offset;
    int64_t shape[N];
    int64_t strides[N];
};

extern "C" void _mlir_ciface_forward(MemRef<float, 2> *output, MemRef<float, 4> *input);

int main() {

    int64_t n = 1;
    int64_t c = 3;
    int64_t h = 224;
    int64_t w = 224;

    MemRef<float, 4> input;
    input.allocated = (float*)malloc(n * c * h * w * sizeof(float));
    input.aligned = input.allocated;
    input.offset = 0;
    input.shape[0] = n;
    input.shape[1] = c;
    input.shape[2] = h;
    input.shape[3] = w;
    input.strides[0] = 1;
    input.strides[1] = c * h * w;
    input.strides[2] = h * w;
    input.strides[3] = w;

    MemRef<float, 2> output;
    output.allocated = (float*)malloc(n * 10 * sizeof(float));
    output.aligned = output.allocated;
    output.offset = 0;
    output.shape[0] = n;
    output.shape[1] = 10;
    output.strides[0] = 1;
    output.strides[1] = 10;

    _mlir_ciface_forward(&output, &input);



    return 0;
}




