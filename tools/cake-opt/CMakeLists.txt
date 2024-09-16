# get_property(dialect_libs GLOBAL PROPERTY MLIR_DIALECT_LIBS)
# get_property(conversion_libs GLOBAL PROPERTY MLIR_CONVERSION_LIBS)

set (
    LIBS
    MLIROptLib
    MLIRPass

    CakeMLIRInitAll
)

if(CAKE_MLIR_ENABLE_STABLEHLO)
  list(APPEND LIBS StablehloRegister)
endif()

add_llvm_executable(cake-opt cake-opt.cc)
llvm_update_compile_flags(cake-opt)
target_link_libraries(cake-opt PRIVATE ${LIBS})
mlir_check_all_link_libraries(cake-opt)

install(TARGETS cake-opt)