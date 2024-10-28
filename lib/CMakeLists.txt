add_subdirectory(Dialect)
add_subdirectory(Transform)
add_subdirectory(Conversion)
if(CAKE_MLIR_ENABLE_TOY)
    add_subdirectory(toy_parser)
endif()
add_subdirectory(Runtime)
add_subdirectory(Bindings)

get_property(dialect_libs GLOBAL PROPERTY MLIR_DIALECT_LIBS)
get_property(conversion_libs GLOBAL PROPERTY MLIR_CONVERSION_LIBS)

set(
    LinkedLibs

    CakeDialect
    CakeMLIRLearnPass

    TorchMLIRInitAll
    
    ${dialect_libs}
    ${conversion_libs}
    MLIRPass
)

if(CAKE_MLIR_ENABLE_STABLEHLO)
list(APPEND LinkedLibs StablehloLinalgTransforms StablehloPasses)
endif()

add_mlir_library(
    CakeMLIRInitAll
    InitAll.cc

    LINK_LIBS PUBLIC
    ${LinkedLibs}
)