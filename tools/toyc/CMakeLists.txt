get_property(dialect_libs GLOBAL PROPERTY MLIR_DIALECT_LIBS)
get_property(conversion_libs GLOBAL PROPERTY MLIR_CONVERSION_LIBS)
get_property(extension_libs GLOBAL PROPERTY MLIR_EXTENSION_LIBS)

add_llvm_executable(toyc toyc.cc)
llvm_update_compile_flags(toyc)
target_link_libraries(
    toyc
    PRIVATE

    ${dialect_libs}
    ${conversion_libs}
    ${extension_libs}

    toy_parser
    ToyDialect
    ToyPasses
    ToyConversion

    MLIRPass
    MLIRTransforms
    MLIRFuncAllExtensions
    MLIRAffineTransforms
    MLIRBuiltinToLLVMIRTranslation
    MLIRLLVMToLLVMIRTranslation
    MLIRExecutionEngine

    LLVMOrcJIT
)
mlir_check_all_link_libraries(toyc)