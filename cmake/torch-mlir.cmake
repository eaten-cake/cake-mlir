set(TORCH_MLIR_ROOT_DIR ${CMAKE_CURRENT_SOURCE_DIR}/3rdparty/torch-mlir)

include_directories(${TORCH_MLIR_ROOT_DIR}/include)
include_directories(${PROJECT_BINARY_DIR})

set(TORCH_MLIR_ENABLE_STABLEHLO ${CAKE_MLIR_ENABLE_STABLEHLO})
message(STATUS ${PROJECT_BINARY_DIR}/torch-mlir/Dialect/Torch/IR/TorchOps.h.inc)
# TorchOps.td
set(LLVM_TARGET_DEFINITIONS ${TORCH_MLIR_ROOT_DIR}/include/torch-mlir/Dialect/Torch/IR/TorchOps.td)
mlir_tablegen(include/torch-mlir/Dialect/Torch/IR/TorchOps.h.inc -gen-op-decls)
mlir_tablegen(include/torch-mlir/Dialect/Torch/IR/TorchOps.cpp.inc -gen-op-defs)
mlir_tablegen(include/torch-mlir/Dialect/Torch/IR/TorchDialect.h.inc -gen-dialect-decls -dialect=torch)
mlir_tablegen(include/torch-mlir/Dialect/Torch/IR/TorchDialect.cpp.inc -gen-dialect-defs -dialect=torch)
add_public_tablegen_target(TorchDialectGen)

# TorchTypes.td
set(LLVM_TARGET_DEFINITIONS ${TORCH_MLIR_ROOT_DIR}/include/torch-mlir/Dialect/Torch/IR/TorchTypes.td)
mlir_tablegen(include/torch-mlir/Dialect/Torch/IR/TorchTypes.h.inc -gen-typedef-decls)
mlir_tablegen(include/torch-mlir/Dialect/Torch/IR/TorchTypes.cpp.inc -gen-typedef-defs)
add_public_tablegen_target(TorchDialectTypesGen)

# Passes.td
set(LLVM_TARGET_DEFINITIONS ${TORCH_MLIR_ROOT_DIR}/include/torch-mlir/Dialect/Torch/Transforms/Passes.td)
mlir_tablegen(include/torch-mlir/Dialect/Torch/Transforms/Passes.h.inc -gen-pass-decls)
mlir_tablegen(include/torch-mlir/Dialect/Torch/Transforms/Transforms.capi.h.inc -gen-pass-capi-header)
mlir_tablegen(include/torch-mlir/Dialect/Torch/Transforms/Transforms.capi.cpp.inc -gen-pass-capi-impl)
add_public_tablegen_target(TorchDialectTransformsGen)

# TorchConversionOps.td
set(LLVM_TARGET_DEFINITIONS ${TORCH_MLIR_ROOT_DIR}/include/torch-mlir/Dialect/TorchConversion/IR/TorchConversionOps.td)
mlir_tablegen(include/torch-mlir/Dialect/TorchConversion/IR/TorchConversionOps.h.inc -gen-op-decls)
mlir_tablegen(include/torch-mlir/Dialect/TorchConversion/IR/TorchConversionOps.cpp.inc -gen-op-defs)
mlir_tablegen(include/torch-mlir/Dialect/TorchConversion/IR/TorchConversionDialect.h.inc -gen-dialect-decls -dialect=torch_c)
mlir_tablegen(include/torch-mlir/Dialect/TorchConversion/IR/TorchConversionDialect.cpp.inc -gen-dialect-defs -dialect=torch_c)
add_public_tablegen_target(TorchConversionDialectGen)

# TorchConversionPasses.td
set(LLVM_TARGET_DEFINITIONS ${TORCH_MLIR_ROOT_DIR}/include/torch-mlir/Dialect/TorchConversion/Transforms/Passes.td)
if(TORCH_MLIR_ENABLE_STABLEHLO)
  mlir_tablegen(include/torch-mlir/Dialect/TorchConversion/Transforms/Passes.h.inc -gen-pass-decls -DTORCH_MLIR_ENABLE_STABLEHLO)
else()
  mlir_tablegen(include/torch-mlir/Dialect/TorchConversion/Transforms/Passes.h.inc -gen-pass-decls)
endif()
mlir_tablegen(include/torch-mlir/Dialect/TorchConversion/Transforms/Transforms.capi.h.inc -gen-pass-capi-header)
mlir_tablegen(include/torch-mlir/Dialect/TorchConversion/Transforms/Transforms.capi.cpp.inc -gen-pass-capi-impl)
add_public_tablegen_target(TorchConversionDialectTransformsGen)

file(GLOB _TorchDialectIR_SRCS "${TORCH_MLIR_ROOT_DIR}/lib/Dialect/Torch/IR/*.cpp")

add_mlir_library(
    TorchDialectIR
    ${_TorchDialectIR_SRCS}
)

