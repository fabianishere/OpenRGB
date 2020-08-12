# - Try to find libusb-1.0 l
#
# The following standard variables get defined:
#  LIBUSB_FOUND:    true if LibUSB was found
#  LIBUSB_INCLUDE_DIR: the directory that contains the include file
#  LIBUSB_LIBRARIES:  the libraries
 if (NOT WIN32)
    # use pkg-config to get the directories and then use these values
    # in the FIND_PATH() and FIND_LIBRARY() calls
    find_package(PkgConfig)
    pkg_check_modules(PC_LIBUSB libusb-1.0)
endif()

find_path(LIBUSB_INCLUDE_DIR "libusb-1.0/libusb.h"
    PATHS ${PC_LIBUSB_INCLUDEDIR} ${PC_LIBUSB_INCLUDE_DIRS})
find_library(LIBUSB_LIBRARIES NAMES usb-1.0
    PATHS ${PC_LIBUSB_LIBDIR} ${PC_LIBUSB_LIBRARY_DIRS})
include(FindPackageHandleStandardArgs)

# handle the QUIETLY and REQUIRED arguments and set LIBUSB_FOUND to TRUE
# if all listed variables are TRUE
find_package_handle_standard_args(LibUSB DEFAULT_MSG LIBUSB_LIBRARIES LIBUSB_INCLUDE_DIR)
mark_as_advanced(LIBUSB_INCLUDE_DIR LIBUSB_LIBRARIES)

add_library(LibUSB::libusb UNKNOWN IMPORTED)
set_property(TARGET LibUSB::libusb PROPERTY IMPORTED_LOCATION ${LIBUSB_LIBRARIES})
set_property(TARGET LibUSB::libusb PROPERTY INTERFACE_INCLUDE_DIRECTORIES ${LIBUSB_INCLUDE_DIR})
