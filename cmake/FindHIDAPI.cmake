# - Try to find HIDAPI
#
# The following standard variables get defined:
#  HIDAPI_FOUND: true if HIDAPI was found
#  HIDAPI_INCLUDE_DIR: the directory that contains the include files
#  HIDAPI_LIBRARIES: the libraries

# Sanitize HIDAPI components
if(HIDAPI_FIND_COMPONENTS)
	if(WIN32 OR APPLE)
        # Windows and Mac provide native APIs
		list(REMOVE HIDAPI_FIND_COMPONENTS libusb)
	endif()

    if(NOT LINUX)
		# hidraw is only on linux
		list(REMOVE HIDAPI_FIND_COMPONENTS} hidraw)
	endif()
else()
	# Default to any
	set(HIDAPI_FIND_COMPONENTS any)
endif()

# Ask pkg-config for hints
find_package(PkgConfig QUIET)
if(PKG_CONFIG_FOUND)
	pkg_check_modules(PC_HIDAPI_LIBUSB QUIET hidapi-libusb)
	pkg_check_modules(PC_HIDAPI_HIDRAW QUIET hidapi-hidraw)
endif()

# Actually search
find_library(HIDAPI_BASE_LIBRARY
	NAMES hidapi
	PATH_SUFFIXES lib)

find_library(HIDAPI_LIBUSB_LIBRARY
	NAMES hidapi hidapi-libusb
    PATH_SUFFIXES lib
	HINTS ${PC_HIDAPI_LIBUSB_LIBRARY_DIRS})

if(LINUX)
	find_library(HIDAPI_HIDRAW_LIBRARY
		NAMES hidapi-hidraw
		HINTS ${PC_HIDAPI_HIDRAW_LIBRARY_DIRS})
endif()

find_path(HIDAPI_INCLUDE_DIR
	NAMES hidapi/hidapi.h
	HINTS
	    ${PC_HIDAPI_HIDRAW_INCLUDE_DIRS}
	    ${PC_HIDAPI_LIBUSB_INCLUDE_DIRS})

find_package(Threads QUIET)

if(HIDAPI_FIND_COMPONENTS MATCHES "libusb" AND HIDAPI_LIBUSB_LIBRARY AND NOT HIDAPI_LIBRARY)
	set(HIDAPI_LIBRARY ${HIDAPI_LIBUSB_LIBRARY})
elseif(HIDAPI_FIND_COMPONENTS MATCHES "hidraw" AND HIDAPI_HIDRAW_LIBRARY AND NOT HIDAPI_LIBRARY)
	set(HIDAPI_LIBRARY ${HIDAPI_HIDRAW_LIBRARY})
else()
	if(HIDAPI_LIBUSB_LIBRARY)
		set(HIDAPI_LIBRARY ${HIDAPI_LIBUSB_LIBRARY})
	elseif(HIDAPI_HIDRAW_LIBRARY)
		set(HIDAPI_LIBRARY ${HIDAPI_HIDRAW_LIBRARY})
    elseif(HIDAPI_BASE_LIBRARY)
        set(HIDAPI_LIBRARY ${HIDAPI_BASE_LIBRARY})
	endif()
endif()

###
# Determine if the various requested components are found.
###
set(_hidapi_component_required_vars)

foreach(_comp IN LISTS HIDAPI_FIND_COMPONENTS)
	if("${_comp}" STREQUAL "any")
		list(APPEND _hidapi_component_required_vars
			HIDAPI_INCLUDE_DIR
			HIDAPI_LIBRARY)
		if(HIDAPI_INCLUDE_DIR AND EXISTS "${HIDAPI_LIBRARY}")
			set(HIDAPI_any_FOUND TRUE)
			mark_as_advanced(HIDAPI_INCLUDE_DIR)
		else()
			set(HIDAPI_any_FOUND FALSE)
		endif()

	elseif("${_comp}" STREQUAL "libusb")
		list(APPEND _hidapi_component_required_vars HIDAPI_INCLUDE_DIR HIDAPI_LIBUSB_LIBRARY)
		if(HIDAPI_INCLUDE_DIR AND EXISTS "${HIDAPI_LIBUSB_LIBRARY}")
			set(HIDAPI_libusb_FOUND TRUE)
			mark_as_advanced(HIDAPI_INCLUDE_DIR HIDAPI_LIBUSB_LIBRARY)
		else()
			set(HIDAPI_libusb_FOUND FALSE)
		endif()

	elseif("${_comp}" STREQUAL "hidraw")
		list(APPEND _hidapi_component_required_vars HIDAPI_INCLUDE_DIR HIDAPI_HIDRAW_LIBRARY)
		if(HIDAPI_INCLUDE_DIR AND EXISTS "${HIDAPI_HIDRAW_LIBRARY}")
			set(HIDAPI_hidraw_FOUND TRUE)
			mark_as_advanced(HIDAPI_INCLUDE_DIR HIDAPI_HIDRAW_LIBRARY)
		else()
			set(HIDAPI_hidraw_FOUND FALSE)
		endif()

	else()
		message(WARNING "${_comp} is not a recognized HIDAPI component")
		set(HIDAPI_${_comp}_FOUND FALSE)
	endif()
endforeach()
unset(_comp)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(HIDAPI
    REQUIRED_VARS ${_hidapi_component_required_vars}
	THREADS_FOUND
	HANDLE_COMPONENTS)

if(HIDAPI_FOUND)
	set(HIDAPI_LIBRARIES "${HIDAPI_LIBRARY}")
	set(HIDAPI_INCLUDE_DIRS "${HIDAPI_INCLUDE_DIR}")
	if(NOT TARGET HIDAPI::hidapi)
	    add_library(HIDAPI::hidapi UNKNOWN IMPORTED)
	    set_target_properties(HIDAPI::hidapi PROPERTIES
		    IMPORTED_LINK_INTERFACE_LANGUAGES "C"
		    IMPORTED_LOCATION ${HIDAPI_LIBRARY}
            INTERFACE_INCLUDE_DIRECTORIES ${HIDAPI_INCLUDE_DIR})
		set_property(TARGET HIDAPI::hidapi PROPERTY
			IMPORTED_LINK_INTERFACE_LIBRARIES Threads::Threads)
	endif()
endif()

if(HIDAPI_libusb_FOUND AND NOT TARGET HIDAPI::hidapi-libusb)
	add_library(HIDAPI::hidapi-libusb UNKNOWN IMPORTED)
	set_target_properties(HIDAPI::hidapi-libusb PROPERTIES
		IMPORTED_LINK_INTERFACE_LANGUAGES "C"
		IMPORTED_LOCATION ${HIDAPI_LIBUSB_LIBRARY})
	set_property(TARGET HIDAPI::hidapi-libusb PROPERTY
		IMPORTED_LINK_INTERFACE_LIBRARIES Threads::Threads)
endif()

if(HIDAPI_hidraw_FOUND AND NOT TARGET HIDAPI::hidapi-hidraw)
	add_library(HIDAPI::hidapi-hidraw UNKNOWN IMPORTED)
	set_target_properties(HIDAPI::hidapi-hidraw PROPERTIES
		IMPORTED_LINK_INTERFACE_LANGUAGES "C"
		IMPORTED_LOCATION ${HIDAPI_HIDRAW_LIBRARY})
	set_property(TARGET HIDAPI::hidapi-hidraw PROPERTY
		IMPORTED_LINK_INTERFACE_LIBRARIES Threads::Threads)
endif()
