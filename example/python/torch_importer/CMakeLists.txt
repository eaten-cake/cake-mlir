cmake_minimum_required(VERSION 3.13)

project(torch_importer)

set(CMAKE_CXX_STANDARD 17)

message(STATUS ${CMAKE_SOURCE_DIR})
link_directories(${CMAKE_SOURCE_DIR})
link_directories(/home/yrx/llvm-project/build/lib)

include_directories(/home/yrx/develop/cake-mlir/include)

add_executable(runtime runtime.cc)

target_link_libraries(runtime PRIVATE model)