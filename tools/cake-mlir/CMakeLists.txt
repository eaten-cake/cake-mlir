get_property(dialect_libs GLOBAL PROPERTY MLIR_DIALECT_LIBS)
get_property(conversion_libs GLOBAL PROPERTY MLIR_CONVERSION_LIBS)

set (
    LIBS
    ${dialect_libs}
    ${conversion_libs}
)

add_llvm_executable(cake-mlir cake-mlir.cc)
llvm_update_compile_flags(cake-mlir)
target_link_libraries(cake-mlir PRIVATE ${LIBS})
mlir_check_all_link_libraries(cake-mlir)

install(TARGETS cake-mlir)

