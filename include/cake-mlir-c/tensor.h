#ifndef CAKE_MLIR_C_TENSOR_H_
#define CAKE_MLIR_C_TENSOR_H_

#include "mlir-c/Support.h"

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

MLIR_CAPI_EXPORTED CakeTensor cakeTensorCreate(int64_t ndim, int64_t *shape);

MLIR_CAPI_EXPORTED void cakeTensorDestroy(CakeTensor tensor);

#ifdef __cplusplus
}
#endif

#endif  // CAKE_MLIR_C_TENSOR_H_