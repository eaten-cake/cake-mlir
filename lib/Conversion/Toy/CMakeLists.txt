add_mlir_library(
    ToyConversion

    ToyToStandard.cc
    ToyToLLVM.cc

    DEPENDS
    ToyConversionIncGen
)