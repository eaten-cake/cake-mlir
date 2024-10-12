set(LLVM_TARGET_DEFINITIONS ToyConversion.td)
mlir_tablegen(ToyConversion.h.inc -gen-pass-decls)
add_public_tablegen_target(ToyConversionIncGen)