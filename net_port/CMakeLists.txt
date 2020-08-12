cmake_minimum_required(VERSION 3.5)

## Target ##
set(OPENRGB_NET_PORT_H
        net_port.h)
set(OPENRGB_NET_PORT_CXX_FLAGS
        $<$<OR:$<C_COMPILER_ID:Clang>,$<C_COMPILER_ID:AppleClang>,$<C_COMPILER_ID:GNU>>:
        -pipe
        $<$<CONFIG:Debug>:-O0 -Wall -Wextra>>
        $<$<C_COMPILER_ID:MSVC>:
        $<$<CONFIG:Debug>:/Od /Wall /Zi>>)

add_library(openrgb-net_port
        ${OPENRGB_NET_PORT_H}
        net_port.cpp)
add_library(OpenRGB::net_port ALIAS openrgb-net_port)
target_include_directories(openrgb-net_port
        PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
target_compile_options(openrgb-net_port PRIVATE ${OPENRGB_NET_PORT_CXX_FLAGS})

