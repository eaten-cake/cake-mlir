set(LLVM_TARGET_DEFINITIONS CakeDialect.td)
mlir_tablegen(CakeDialect.h.inc -gen-dialect-decls)
mlir_tablegen(CakeDialect.cpp.inc -gen-dialect-defs)
add_public_tablegen_target(CakeDialectIncGen)

set(LLVM_TARGET_DEFINITIONS CakeOps.td)
mlir_tablegen(CakeOps.h.inc -gen-op-decls)
mlir_tablegen(CakeOps.cpp.inc -gen-op-defs)
add_public_tablegen_target(CakeDialectOpsIncGen)

