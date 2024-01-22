cmake_minimum_required(VERSION 3.10)

project(Plsan)

# Add source files to the project
set(SOURCES
    plsan.cpp
    plsan_handler.cpp
    plsan_shadow.cpp
)

# Add header files to the project
set(HEADERS
    plsan.h
    plsan_handler.h
    plsan_shadow.h
)

# Add library target
add_library(plsan STATIC ${SOURCES} ${HEADERS})

# Specify include directories
target_include_directories(plsan PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})
