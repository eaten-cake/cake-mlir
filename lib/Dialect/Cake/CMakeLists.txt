add_mlir_dialect_library(
    CakeDialect
    CakeDialect.cc
    CakeOps.cc

    DEPENDS
    CakeDialectIncGen
    CakeDialectOpsIncGen
)