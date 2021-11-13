cmake_minimum_required(VERSION 3.10.2)

project(Rectangle)

set(SRC Rectangle.cpp)

set(CMAKE_BUILD_TYPE Release)

add_library(Rectangle SHARED ${SRC})

install(TARGETS Rectangle DESTINATION ./)

add_executable(main main.cpp Rectangle.cpp)



