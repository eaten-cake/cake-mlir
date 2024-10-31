#ifndef CAKE_MLIR_C_TENSOR_H_
#define CAKE_MLIR_C_TENSOR_H_

#include <stdint.h>
#include <dlpack/dlpack.h>

//===----------------------------------------------------------------------===//
// Visibility annotations.
// Use MLIR_CAPI_EXPORTED for exported functions.
//
// On Windows, if MLIR_CAPI_ENABLE_WINDOWS_DLL_DECLSPEC is defined, then
// __declspec(dllexport) and __declspec(dllimport) will be generated. This
// can only be enabled if actually building DLLs. It is generally, mutually
// exclusive with the use of other mechanisms for managing imports/exports
// (i.e. CMake's WINDOWS_EXPORT_ALL_SYMBOLS feature).
//===----------------------------------------------------------------------===//

#if (defined(_WIN32) || defined(__CYGWIN__)) &&                                \
    !defined(MLIR_CAPI_ENABLE_WINDOWS_DLL_DECLSPEC)
// Visibility annotations disabled.
#define MLIR_CAPI_EXPORTED
#elif defined(_WIN32) || defined(__CYGWIN__)
// Windows visibility declarations.
#if MLIR_CAPI_BUILDING_LIBRARY
#define MLIR_CAPI_EXPORTED __declspec(dllexport)
#else
#define MLIR_CAPI_EXPORTED __declspec(dllimport)
#endif
#else
// Non-windows: use visibility attributes.
#define MLIR_CAPI_EXPORTED __attribute__((visibility("default")))
#endif

#ifdef __cplusplus
extern "C" {
#endif

#define DEFINE_C_API_STRUCT(name, storage)                                     \
  struct name {                                                                \
    storage *ptr;                                                              \
  };                                                                           \
  typedef struct name name

DEFINE_C_API_STRUCT(CakeTensor, void);

#undef DEFINE_C_API_STRUCT

MLIR_CAPI_EXPORTED CakeTensor cakeTensorCreate(int32_t ndim, int64_t* shape, DLDataType type);

MLIR_CAPI_EXPORTED void cakeTensorDestroy(CakeTensor tensor);

#ifdef __cplusplus
}
#endif

#endif  // CAKE_MLIR_C_TENSOR_H_