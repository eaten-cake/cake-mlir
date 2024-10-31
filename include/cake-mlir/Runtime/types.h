#ifndef CAKE_MLIR_RUNTIME_TYPES_H_
#define CAKE_MLIR_RUNTIME_TYPES_H_

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef enum {
    /* IEEE 754 single-precision floating-point format */
    kFloat = 0U,
    /* Signed integer format */
    kInt = 1U,
    /* Unsigned integer format */
    kUInt = 2U,
    /* Complex number format */
    kComplex = 3U,
    /* Boolean format */
    kBool = 4U,
} DataTypeCode;

typedef struct {
    /* The data type code */
    uint8_t code;
    /* The number of bits in the data type */
    uint8_t bits;
    /*! Number of lanes in the type, used for vector types. */
    uint16_t lans;
} DataType;

#ifdef __cplusplus
}
#endif

#endif // CAKE_MLIR_RUNTIME_TYPES_H_