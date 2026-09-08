include(FetchContent)
FetchContent_Declare(
  googletest
  URL https://github.com/google/googletest/archive/refs/tags/v1.14.0.zip
  DOWNLOAD_EXTRACT_TIMESTAMP true
  )
set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
FetchContent_MakeAvailable(googletest)

add_executable(unit_tests
    tests/test_board_load.cpp
    tests/test_board_indexing.cpp
    tests/test_board_solve.cpp
    tests/test_board_print.cpp
)

target_include_directories(unit_tests PRIVATE
    ${CMAKE_SOURCE_DIR}/SudokuSolver/engine/include
)

target_compile_definitions(unit_tests PRIVATE
    SUDOKU_CONTENT_DIR="${CMAKE_SOURCE_DIR}/SudokuSolver/content/sudokus"
    SUDOKU_FIXTURES_DIR="${CMAKE_SOURCE_DIR}/unit_tests/fixtures"
)

target_link_libraries(unit_tests PRIVATE engine gtest_main)

include(GoogleTest)
gtest_discover_tests(unit_tests)