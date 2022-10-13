cmake_minimum_required(VERSION 3.13)
set(CMAKE_CUDA_COMPILER "/usr/local/cuda-11.2/bin/nvcc")

project(CudaProjects LANGUAGES CUDA CXX)

set(CMAKE_CUDA_STANDARD 14)
include_directories("/usr/local/cuda-11.2/targets/x86_64-linux/include/")
set(CUDA_LINK_LIBRARIES_KEYWORD PUBLIC)

find_package(Boost REQUIRED COMPONENTS
        filesystem iostreams)
include_directories(${Boost_INCLUDE_DIRS})

add_executable(CudaProjects main.cpp simulators/Simulator.cu simulators/Simulator.cuh parsers/input_parser.cpp
        parsers/input_parser.h simulationParameters.cpp SimulationParameters.h)

set_target_properties(CudaProjects PROPERTIES
        CUDA_SEPARABLE_COMPILATION ON)

set(CMAKE_CUDA_FLAGS "-arch=sm_75")

target_link_libraries(CudaProjects Boost::filesystem
        Boost::iostreams -lcurand)
