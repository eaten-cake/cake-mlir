option(CAKE_MLIR_ENABLE_TORCH_MLIR "Enable torch-mlir integration" ON)

if(CAKE_MLIR_ENABLE_TORCH_MLIR)
    message(STATUS "Enabling torch-mlir integration")
    add_definitions(-DCAKE_MLIR_ENABLE_TORCH_MLIR)

    set(TORCH_MLIR_ROOT_DIR ${CMAKE_CURRENT_SOURCE_DIR}/3rdparty/torch-mlir)

    include_directories(${TORCH_MLIR_ROOT_DIR}/include)

    set(TORCH_MLIR_ENABLE_STABLEHLO ${CAKE_MLIR_ENABLE_STABLEHLO})
    if(TORCH_MLIR_ENABLE_STABLEHLO)
      add_definitions(-DTORCH_MLIR_ENABLE_STABLEHLO)
    endif()

    ###############################################################################
    # Tablegen
    ###############################################################################

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

    # ConversionPasses.td
    set(LLVM_TARGET_DEFINITIONS ${TORCH_MLIR_ROOT_DIR}/include/torch-mlir/Conversion/Passes.td)
    if(TORCH_MLIR_ENABLE_STABLEHLO)
      mlir_tablegen(include/torch-mlir/Conversion/Passes.h.inc -gen-pass-decls -DTORCH_MLIR_ENABLE_STABLEHLO)
      else()
      mlir_tablegen(include/torch-mlir/Conversion/Passes.h.inc -gen-pass-decls)
    endif()
    mlir_tablegen(include/torch-mlir/Conversion/Passes.capi.h.inc -gen-pass-capi-header)
    mlir_tablegen(include/torch-mlir/Conversion/Passes.capi.cpp.inc -gen-pass-capi-impl)
    add_public_tablegen_target(ConversionPassesGen)

    # TorchOnnxToTorchPasses.td
    set(LLVM_TARGET_DEFINITIONS ${TORCH_MLIR_ROOT_DIR}/include/torch-mlir/Conversion/TorchOnnxToTorch/Passes.td)
    if(TORCH_MLIR_ENABLE_STABLEHLO)
        mlir_tablegen(include/torch-mlir/Conversion/TorchOnnxToTorch/Passes.h.inc -gen-pass-decls -DTORCH_MLIR_ENABLE_STABLEHLO)
    else()
        mlir_tablegen(include/torch-mlir/Conversion/TorchOnnxToTorch/Passes.h.inc -gen-pass-decls)
    endif()
    mlir_tablegen(include/torch-mlir/Conversion/TorchOnnxToTorch/Passes.capi.h.inc -gen-pass-capi-header)
    mlir_tablegen(include/torch-mlir/Conversion/TorchOnnxToTorch/Passes.capi.cpp.inc -gen-pass-capi-impl)
    add_public_tablegen_target(TorchOnnxToTorchPassesGen)

    set(_TORCH_MLIR_DIALECTS_DIR ${TORCH_MLIR_ROOT_DIR})

    # TMTensorInterfaces.td
    set(LLVM_TARGET_DEFINITIONS ${_TORCH_MLIR_DIALECTS_DIR}/include/torch-mlir-dialects/Dialect/TMTensor/IR/TMTensorInterfaces.td)
    mlir_tablegen(include/torch-mlir-dialects/Dialect/TMTensor/IR/TMTensorOpInterfaces.h.inc -gen-op-interface-decls)
    mlir_tablegen(include/torch-mlir-dialects/Dialect/TMTensor/IR/TMTensorOpInterfaces.cpp.inc -gen-op-interface-defs)
    mlir_tablegen(include/torch-mlir-dialects/Dialect/TMTensor/IR/TMTensorTypeInterfaces.h.inc -gen-type-interface-decls)
    mlir_tablegen(include/torch-mlir-dialects/Dialect/TMTensor/IR/TMTensorTypeInterfaces.cpp.inc -gen-type-interface-defs)
    add_public_tablegen_target(TMTensorInterfacesIncGen)

    # ScalarLoopOpInterface.td
    set(LLVM_TARGET_DEFINITIONS ${_TORCH_MLIR_DIALECTS_DIR}/include/torch-mlir-dialects/Dialect/TMTensor/IR/ScalarLoopOpInterface.td)
    mlir_tablegen(include/torch-mlir-dialects/Dialect/TMTensor/IR/ScalarLoopOpInterface.h.inc -gen-op-interface-decls)
    mlir_tablegen(include/torch-mlir-dialects/Dialect/TMTensor/IR/ScalarLoopOpInterface.cpp.inc -gen-op-interface-defs)
    add_public_tablegen_target(TMTensorScalarLoopOpInterfaceIncGen)

    # TMTensorOps.td
    set(LLVM_TARGET_DEFINITIONS ${_TORCH_MLIR_DIALECTS_DIR}/include/torch-mlir-dialects/Dialect/TMTensor/IR/TMTensorOps.td)
    mlir_tablegen(include/torch-mlir-dialects/Dialect/TMTensor/IR/TMTensorDialect.h.inc -gen-dialect-decls -dialect=tm_tensor)
    mlir_tablegen(include/torch-mlir-dialects/Dialect/TMTensor/IR/TMTensorDialect.cpp.inc -gen-dialect-defs -dialect=tm_tensor)
    mlir_tablegen(include/torch-mlir-dialects/Dialect/TMTensor/IR/TMTensorOps.h.inc -gen-op-decls)
    mlir_tablegen(include/torch-mlir-dialects/Dialect/TMTensor/IR/TMTensorOps.cpp.inc -gen-op-defs)
    mlir_tablegen(include/torch-mlir-dialects/Dialect/TMTensor/IR/TMTensorTypes.h.inc -gen-typedef-decls)
    mlir_tablegen(include/torch-mlir-dialects/Dialect/TMTensor/IR/TMTensorTypes.cpp.inc -gen-typedef-defs)
    add_public_tablegen_target(TMTensorDialectGen)

    # TMTensorTransforms.td
    set(LLVM_TARGET_DEFINITIONS ${_TORCH_MLIR_DIALECTS_DIR}/include/torch-mlir-dialects/Dialect/TMTensor/Transforms/Passes.td)
    mlir_tablegen(include/torch-mlir-dialects/Dialect/TMTensor/Transforms/Passes.h.inc -gen-pass-decls)
    mlir_tablegen(include/torch-mlir-dialects/Dialect/TMTensor/Transforms/Passes.capi.h.inc -gen-pass-capi-header)
    mlir_tablegen(include/torch-mlir-dialects/Dialect/TMTensor/Transforms/Passes.capi.cpp.inc -gen-pass-capi-impl)
    add_public_tablegen_target(TMTensorDialectTransformsGen)

    ###############################################################################
    # Libraries
    ###############################################################################

    # TorchMLIRTorchDialect
    file(GLOB _TorchDialectIR_SRCS "${TORCH_MLIR_ROOT_DIR}/lib/Dialect/Torch/IR/*.cpp")
    add_mlir_library(
        TorchMLIRTorchDialect
        ${_TorchDialectIR_SRCS}
    )

    # TorchMLIRTorchUtils
    file(GLOB _TorchDialectUtils_SRCS "${TORCH_MLIR_ROOT_DIR}/lib/Dialect/Torch/Utils/*.cpp")
    add_mlir_library(TorchMLIRTorchUtils
        ${_TorchDialectUtils_SRCS}
    )

    # TorchMLIRTorchPasses
    file(GLOB _TorchDialectPasses_SRCS "${TORCH_MLIR_ROOT_DIR}/lib/Dialect/Torch/Transforms/*.cpp")
    add_mlir_library(
        TorchMLIRTorchPasses
        ${_TorchDialectPasses_SRCS}
        LINK_LIBS PUBLIC
        TorchMLIRTorchDialect
        TorchMLIRTorchUtils
    )

    # TorchMLIRTorchConversionDialect
    file(GLOB _TorchConversionDialectIR_SRCS "${TORCH_MLIR_ROOT_DIR}/lib/Dialect/TorchConversion/IR/*.cpp")
    add_mlir_library(TorchMLIRTorchConversionDialect
        ${_TorchConversionDialectIR_SRCS}
    )

    # TorchMLIRConversionUtils
    file(GLOB _TorchMLIRConversionUtils_SRCS "${TORCH_MLIR_ROOT_DIR}/lib/Conversion/Utils/*.cpp")
    add_mlir_conversion_library(
        TorchMLIRConversionUtils
        ${_TorchMLIRConversionUtils_SRCS}
        LINK_LIBS PUBLIC
        TorchMLIRTorchDialect
    )

    # TorchMLIRTorchToStablehlo
    file(GLOB _TorchMLIRTorchToStablehlo_SRCS "${TORCH_MLIR_ROOT_DIR}/lib/Conversion/TorchToStablehlo/*.cpp")
    add_mlir_library(
        TorchMLIRTorchToStablehlo
        ${_TorchMLIRTorchToStablehlo_SRCS}
        LINK_LIBS PUBLIC
        ChloOps
        StablehloOps
        TorchMLIRTorchDialect
        TorchMLIRConversionUtils
    )

    # ConversionPasses
    # Torch to * dialects
    file(GLOB _ConversionPasses_SRCS
      "${TORCH_MLIR_ROOT_DIR}/lib/Conversion/TorchToArith/*.cpp"
      "${TORCH_MLIR_ROOT_DIR}/lib/Conversion/TorchToLinalg/*.cpp"
      "${TORCH_MLIR_ROOT_DIR}/lib/Conversion/TorchConversionToMLProgram/*.cpp"
      "${TORCH_MLIR_ROOT_DIR}/lib/Conversion/TorchToSCF/*.cpp"
      "${TORCH_MLIR_ROOT_DIR}/lib/Conversion/TorchToTensor/*.cpp"
      "${TORCH_MLIR_ROOT_DIR}/lib/Conversion/TorchToTosa/*.cpp"
      "${TORCH_MLIR_ROOT_DIR}/lib/Conversion/TorchToTMTensor/*.cpp"
      "${TORCH_MLIR_ROOT_DIR}/lib/Conversion/Utils/*.cpp"
      "${TORCH_MLIR_ROOT_DIR}/lib/Dialect/TorchConversion/Transforms/*.cpp"
    )
    set(CONVERSION_PASSES_LINK_LIBS)
    if(TORCH_MLIR_ENABLE_STABLEHLO)
      list(APPEND CONVERSION_PASSES_LINK_LIBS TorchMLIRTorchToStablehlo)
    endif()
    add_mlir_library(
        ConversionPasses
        ${_ConversionPasses_SRCS}

        LINK_LIBS PUBLIC
        ${CONVERSION_PASSES_LINK_LIBS}
    )

    # TorchMLIRConversionPasses
    file(GLOB _TorchMLIRConversionPasses_SRCS
      "${_TORCH_MLIR_DIALECTS_DIR}/lib/Conversion/*.cpp")
    add_mlir_library(   
        TorchMLIRConversionPasses
        ${_TorchMLIRConversionPasses_SRCS}
        LINK_LIBS PUBLIC
        ConversionPasses
    )

    # TorchMLIRTorchOnnxToTorch
    file(GLOB _TorchOnnxToTorchPasses_SRCS
      "${TORCH_MLIR_ROOT_DIR}/lib/Conversion/TorchOnnxToTorch/*.cpp"
    )
    add_mlir_conversion_library(
        TorchMLIRTorchOnnxToTorch
        ${_TorchOnnxToTorchPasses_SRCS}
        LINK_LIBS PUBLIC
        TorchMLIRTorchDialect
    )

    # TorchMLIRTMTensorDialect
    file(GLOB _TMTensorDialectIR_SRCS
      "${_TORCH_MLIR_DIALECTS_DIR}/lib/Dialect/TMTensor/IR/*.cpp")
    add_mlir_library(
        TorchMLIRTMTensorDialect
        ${_TMTensorDialectIR_SRCS}
    )

    # TorchMLIRTMTensorPasses
    file(GLOB _TorchMLIRTMTensorPasses_SRCS
      "${_TORCH_MLIR_DIALECTS_DIR}/lib/Dialect/TMTensor/Transforms/*.cpp")
    add_mlir_library(
        TorchMLIRTMTensorPasses
        ${_TorchMLIRTMTensorPasses_SRCS}
        LINK_LIBS PUBLIC
        TorchMLIRTMTensorDialect
    )

    # TorchMLIRTorchConversionPasses
    file(GLOB _TorchMLIRTorchConversionPasses_SRCS
      "${_TORCH_MLIR_DIALECTS_DIR}/lib/Dialect/TorchConversion/Transforms/*.cpp")
    set(
        TorchMLIRTorchConversionPasses_LINK_LIBS
        TorchMLIRTorchConversionDialect
        TorchMLIRTorchDialect
        TorchMLIRTorchPasses
        TorchMLIRConversionPasses
    )
    if(TORCH_MLIR_ENABLE_STABLEHLO)
        list(APPEND TorchMLIRTorchConversionPasses_LINK_LIBS
            StablehloOps
            StablehloPasses
        )
    endif()
    add_mlir_library(   
        TorchMLIRTorchConversionPasses
        ${_TorchMLIRTorchConversionPasses_SRCS}

        ADDITIONAL_HEADER_DIRS
        ${TORCH_MLIR_ROOT_DIR}/include/torch-mlir/Dialect/TorchConversion/Transforms

        LINK_LIBS PUBLIC
        ${TorchMLIRTorchConversionPasses_LINK_LIBS}
    )

    # TorchMLIRInitAll
    set(LinkedLibs
      MLIRComplexDialect
      MLIRFuncDialect
      MLIRFuncInlinerExtension
      MLIRIR
      MLIRMLProgramDialect
      MLIRMemRefDialect
      MLIRSCFDialect
      MLIRTensorDialect
      MLIRTensorInferTypeOpInterfaceImpl
      MLIRTosaDialect
      MLIRSupport

      # Dialects.
      TorchMLIRTMTensorDialect
      TorchMLIRTorchDialect
      TorchMLIRTorchConversionDialect

      # Dialect passes.
      TorchMLIRTMTensorPasses
      TorchMLIRTorchConversionPasses
      TorchMLIRTorchPasses

      # Conversion passes.
      TorchMLIRConversionPasses
      TorchMLIRTorchOnnxToTorch
    )
    add_mlir_library(TorchMLIRInitAll
      ${TORCH_MLIR_ROOT_DIR}/lib/InitAll.cpp
      LINK_LIBS PUBLIC
      ${LinkedLibs}
    )

    ###############################################################################
    # CAPI
    ###############################################################################

    file(GLOB _CAPI_SRCS
      "${TORCH_MLIR_ROOT_DIR}/lib/CAPI/*.cpp"
    )
    # TODO: The way that torch-mlir is doing registration is overly broad.
    # It may not be necessary: IREE's registration is already accounting for
    # plugins, which includes torch-mlir.
    # list(FILTER _CAPI_SRCS EXCLUDE REGEX Registration.cpp)
    add_mlir_public_c_api_library(TorchMLIRCAPI
        ${_CAPI_SRCS}

        ADDITIONAL_HEADER_DIRS
        ${TORCH_MLIR_ROOT_DIR}/include/torch-mlir-c/

        ENABLE_AGGREGATION

        LINK_LIBS PUBLIC
        MLIRIR
        MLIRSupport
        TorchMLIRTorchDialect
        TorchMLIRInitAll
        TorchMLIRTorchPasses
    )

endif()

