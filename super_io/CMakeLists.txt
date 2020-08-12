cmake_minimum_required(VERSION 3.5)

## Target ##
set(OPENRGB_SUPER_IO_H
        super_io.h)
set(OPENRGB_SUPER_IO_CXX_FLAGS
        $<$<OR:$<C_COMPILER_ID:Clang>,$<C_COMPILER_ID:AppleClang>,$<C_COMPILER_ID:GNU>>:
        -pipe
        $<$<CONFIG:Debug>:-O0 -Wall -Wextra>>
        $<$<C_COMPILER_ID:MSVC>:
        $<$<CONFIG:Debug>:/Od /Wall /Zi>>)

add_library(openrgb-super_io
        ${OPENRGB_SUPER_IO_H}
        super_io.cpp)
add_library(OpenRGB::super_io ALIAS openrgb-super_io)
target_include_directories(openrgb-super_io
        PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
target_compile_options(openrgb-super_io PRIVATE ${OPENRGB_SUPER_IO_CXX_FLAGS})

