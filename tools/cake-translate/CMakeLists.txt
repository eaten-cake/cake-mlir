get_property(dialect_libs GLOBAL PROPERTY MLIR_DIALECT_LIBS)
get_property(translation_libs GLOBAL PROPERTY MLIR_TRANSLATION_LIBS)


set (
    LIBS

    ${dialect_libs}
    ${translation_libs}

    MLIRIR
    MLIRParser
    MLIRPass
    MLIRSPIRVDialect
    MLIRTranslateLib
    MLIRSupport
)

add_llvm_executable(cake-translate cake-translate.cc)
llvm_update_compile_flags(cake-translate)
target_link_libraries(cake-translate PRIVATE ${LIBS})
mlir_check_all_link_libraries(cake-translate)

install(TARGETS cake-translate)