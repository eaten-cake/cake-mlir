cmake_minimum_required(VERSION 3.13)

project(torch_importer)

set(CMAKE_CXX_STANDARD 17)

add_executable(runtime runtime.cc)

link_directories(${CMAKE_SOURCE_DIR})

link_libraries(runtime PRIVATE model)