add_mlir_library(
    ToyPasses
    ShapeInference.cc

    DEPENDS
    ToyPassesIncGen
)