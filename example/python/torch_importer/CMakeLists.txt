cmake_minimum_required(VERSION 3.13)

project(torch_importer)

set(CMAKE_CXX_STANDARD 17)

include_directories(/home/yrx/develop/cake-mlir/include)
link_directories(/home/yrx/develop/cake-mlir/build/lib)

add_executable(runtime runtime.cc)

target_link_libraries(runtime cake_runtime dl)