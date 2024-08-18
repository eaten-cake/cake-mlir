cmake_minimum_required(VERSION 3.20)

project(cake-mlir LANGUAGES CXX C)

include(cmake/toolchain.cmake)

include(cmake/MLIR.cmake)

add_subdirectory(tests)
add_subdirectory(lib)
add_subdirectory(tools)
add_subdirectory(include)