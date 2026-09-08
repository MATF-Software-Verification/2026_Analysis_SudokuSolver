cmake_minimum_required(VERSION 3.14)
project(SudokuSolverAnalysis)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

enable_testing()

option(ENABLE_COVERAGE "Build with coverage instrumentation" OFF)
if(ENABLE_COVERAGE)
  add_compile_options(--coverage -O0 -g)
  add_link_options(--coverage)
endif()

add_subdirectory(SudokuSolver/engine ${CMAKE_BINARY_DIR}/engine)
add_subdirectory(unit_tests)