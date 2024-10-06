add_executable(
    toyc
    toyc.cc
)

target_link_libraries(toyc
    toy_parser
    ToyDialect
)