add_mlir_dialect_library(
    ToyDialect
    ToyDialect.cc
    ToyOps.cc

    DEPENDS
    ToyDialectIncGen
    ToyDialectOpsIncGen
    ToyCanonicalizeIncGen
    ToyInterfaceIncGen
)

target_link_libraries(
    ToyDialect
    PRIVATE
    
    MLIRCastInterfaces
)