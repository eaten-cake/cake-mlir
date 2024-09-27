set(LLVM_TARGET_DEFINITIONS LearnPass.td)
mlir_tablegen(LearnPass.h.inc -gen-pass-decls)
add_public_tablegen_target(CakeMLIRLearnPassGen)