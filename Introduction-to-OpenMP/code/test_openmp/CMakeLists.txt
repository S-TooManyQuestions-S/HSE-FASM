cmake_minimum_required(VERSION 3.9)
project(test_openmp) # you can change the project name
set(CMAKE_CXX_STANDARD 17)

find_package(OpenMP)

add_executable(test_openmp main.cpp) # you can change the excutable name

if(OpenMP_CXX_FOUND)
    target_link_libraries(test_openmp PUBLIC OpenMP::OpenMP_CXX)
endif()


