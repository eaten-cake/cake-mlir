add_llvm_executable(toyc toyc.cc)
llvm_update_compile_flags(toyc)
target_link_libraries(
    toyc
    PRIVATE

    toy_parser
    ToyDialect

    MLIRPass
    MLIRTransforms
)
mlir_check_all_link_libraries(toyc)