set(LLVM_TARGET_DEFINITIONS CakeDialect.td)
mlir_tablegen(CakeDialect.h.inc -gen-dialect-decls)
mlir_tablegen(CakeDialect.cpp.inc -gen-dialect-defs)
add_public_tablegen_target(CakeDialectIncGen)

