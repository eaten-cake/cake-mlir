#include "cake-mlir/Runtime/module.h"

#include <dlfcn.h>

namespace cake {
namespace runtime {

void Module::set_lib_path(const std::string& lib_path) {
    _lib_path = lib_path;
}

void Module::set_handle(void* handle) {
    _handle = handle;
}

Module Module::load(const std::string& lib_path) {
    Module module;

    module.set_lib_path(lib_path);

    void* handle = dlopen(lib_path.c_str(), RTLD_LAZY);
    if (!handle) {
        throw std::runtime_error("Failed to load library: " + lib_path + " (" + dlerror() + ")");
    }

    module.set_handle(handle);

    

    return module;
}

} // namespace runtime
} // namespace cake