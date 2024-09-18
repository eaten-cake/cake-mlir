cmake_minimum_required(VERSION 3.20)

if(POLICY CMP0116)
  cmake_policy(SET CMP0116 NEW)
endif()

project(cake-mlir LANGUAGES CXX C)

set(CakeMLIR_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR})

include(cmake/toolchain.cmake)
include(cmake/MLIR.cmake)
include(cmake/stablehlo.cmake)
include(cmake/torch-mlir.cmake)

add_subdirectory(tests)
add_subdirectory(lib)
add_subdirectory(tools)
add_subdirectory(include)

# enable Python API
if(MLIR_ENABLE_BINDINGS_PYTHON)
  message(STATUS "Enabling Python API")
  add_subdirectory(python)
endif()

# use custom target
include(cmake/targets.cmake)