cmake_minimum_required(VERSION 3.5)

## Target ##
set(OPENRGB_SERIAL_PORT_H
        serial_port.h
        find_usb_serial_port.h)
set(OPENRGB_SERIAL_PORT_CXX_FLAGS
        $<$<OR:$<C_COMPILER_ID:Clang>,$<C_COMPILER_ID:AppleClang>,$<C_COMPILER_ID:GNU>>:
        -pipe
        $<$<CONFIG:Debug>:-O0 -Wall -Wextra>>
        $<$<C_COMPILER_ID:MSVC>:
        $<$<CONFIG:Debug>:/Od /Wall /Zi>>)

add_library(openrgb-serial_port
        ${OPENRGB_SERIAL_PORT_H}
        serial_port.cpp
        $<$<PLATFORM_ID:Linux>:find_usb_serial_port_linux.cpp>
        $<$<PLATFORM_ID:Windows>:find_usb_serial_port_win.cpp>)
add_library(OpenRGB::serial_port ALIAS openrgb-serial_port)
target_include_directories(openrgb-serial_port
        PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
target_compile_options(openrgb-serial_port PRIVATE ${OPENRGB_SERIAL_PORT_CXX_FLAGS})

