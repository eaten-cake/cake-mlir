option(CAKE_MLIR_ENABLE_STABLEHLO "Add stablehlo dialect" ON)

if(CAKE_MLIR_ENABLE_STABLEHLO)
  add_definitions(-DCAKE_MLIR_ENABLE_STABLEHLO)
endif()

if (CAKE_MLIR_ENABLE_STABLEHLO)
  set(STABLEHLO_BUILD_EMBEDDED ON)
  set(STABLEHLO_ENABLE_BINDINGS_PYTHON ON)
  add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/3rdparty/stablehlo
    ${CMAKE_CURRENT_BINARY_DIR}/stablehlo
    EXCLUDE_FROM_ALL)
  include_directories(${CMAKE_CURRENT_SOURCE_DIR}/3rdparty/stablehlo)
  include_directories(${CMAKE_CURRENT_BINARY_DIR}/stablehlo)
endif()