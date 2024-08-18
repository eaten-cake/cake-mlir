set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 17)

set(
    OPTIONS
    "-Wno-unused-but-set-parameter -Wno-unused-but-set-variable"
)
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${OPTIONS}")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${OPTIONS}")

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)