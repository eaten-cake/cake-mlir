#ifndef CAKE_MLIR_RUNTIME_MODULE_H_
#define CAKE_MLIR_RUNTIME_MODULE_H_

#include <functional>

namespace cake {
namespace runtime {

template<typename ReturnType, typename... Args>
std::function<ReturnType(Args...)> load_function(void* handle, const char* name) {
    auto func = (ReturnType(*)(Args...))dlsym(handle, name);
    if(!func) {
        std::cerr << "Could not load function: " << name << std::endl;
        std::exit(1);
    }
    return std::function<ReturnType(Args...)>(func);
}

class Module {
public:
    Module() {}

    static Module load(const std::string& lib_path);

    void set_lib_path(const std::string& lib_path);

    void set_handle(void* handle);

    void set_input();

    void get_output();

    void init();

    void run();

private:
    std::string _lib_path;
    void* _handle = nullptr;
};

} // namespace runtime
} // namespace cake

#endif // CAKE_MLIR_RUNTIME_MODULE_H_