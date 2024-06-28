cmake_minimum_required(VERSION 3.28)
project(qredshift C)

set(CMAKE_C_STANDARD 11)

set(CMAKE_C_FLAGS "-O3")

add_executable(qredshift src/main.c
        src/utils/gamma_ramp.c
        src/display_servers/x11_randr.c
        src/display_servers/xcb_randr.c
)

find_package(PkgConfig REQUIRED)


find_library(X11_LIBRARIES X11)
find_library(XRANDR_LIBRARY Xrandr)
find_path(XRANDR_INCLUDE_DIR X11/extensions/Xrandr.h)

#find_library(WAYLAND_LIBRARIES wayland-client)

#pkg_check_modules(DBUS REQUIRED dbus-1)
#pkg_check_modules(GLIB REQUIRED glib-2.0)

#find_library(DBUS_LIBRARIES dbus-1)
#find_library(GLIB_LIBRARIES glib-2.0)
pkg_check_modules(XCB REQUIRED xcb)
pkg_check_modules(XCB_RANDR REQUIRED xcb-randr)


#target_link_libraries(qredshift ${X11_LIBRARIES} ${XRANDR_LIBRARY} ${WAYLAND_LIBRARIES} ${DBUS_LIBRARIES} ${GLIB_LIBRARIES} m)
target_link_libraries(qredshift ${X11_LIBRARIES} ${XRANDR_LIBRARY} ${XCB_LIBRARIES} ${XCB_RANDR_LIBRARIES} m)

include_directories(${X11_INCLUDE_DIR} ${XRANDR_INCLUDE_DIR} ${XCB_INCLUDE_DIRS} ${XCB_RANDR_INCLUDE_DIRS})

#include_directories(${DBUS_INCLUDE_DIRS})
#include_directories(${GLIB_INCLUDE_DIRS})

