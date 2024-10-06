add_library(
    toy_parser
    AST.cc
    MLIRGen.cc
)

target_link_libraries(
    toy_parser
    PRIVATE
    LLVMSupport

    MLIRIR
    MLIRParser
    MLIRFunctionInterfaces
)