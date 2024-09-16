set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 17)

option(CAKEMLIR_ENABLE_LLD "Use LLD as the linker if available" OFF)

add_compile_options("-Wno-unused-but-set-parameter")
add_compile_options("-Wno-unused-but-set-variable")
add_compile_options("-Wno-unused-variable")

if (CAKEMLIR_ENABLE_LLD)
  message(STATUS "Enabling LLD as the linker")
  add_link_options("-fuse-ld=lld")
endif()

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)