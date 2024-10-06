set(LLVM_TARGET_DEFINITIONS ToyDialect.td)
mlir_tablegen(ToyDialect.h.inc -gen-dialect-decls)
mlir_tablegen(ToyDialect.cpp.inc -gen-dialect-defs)
add_public_tablegen_target(ToyDialectIncGen)

set(LLVM_TARGET_DEFINITIONS ToyOps.td)
mlir_tablegen(ToyOps.h.inc -gen-op-decls)
mlir_tablegen(ToyOps.cpp.inc -gen-op-defs)
add_public_tablegen_target(ToyDialectOpsIncGen)

set(LLVM_TARGET_DEFINITIONS ToyPatterns.td)
mlir_tablegen(ToyCanonicalize.cpp.inc -gen-rewriters)
add_public_tablegen_target(ToyCanonicalizeIncGen)