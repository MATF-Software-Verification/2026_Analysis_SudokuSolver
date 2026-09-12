#!/bin/bash

set -e   

mkdir -p build-mutation
mkdir -p mutation-testing

clang++ -std=c++14 -O0 -g -grecord-command-line \
  -ISudokuSolver/engine/include \
  -c -emit-llvm SudokuSolver/engine/src/Board.cpp \
  -o build-mutation/Board.bc

clang++ -std=c++14 -O0 -g -grecord-command-line \
  -ISudokuSolver/engine/include \
  -c -emit-llvm SudokuSolver/engine/src/SolveResult.cpp \
  -o build-mutation/SolveResult.bc

mull-instrument-22 build-mutation/Board.bc \
  -o build-mutation/Board-mutated.bc

mull-instrument-22 build-mutation/SolveResult.bc \
  -o build-mutation/SolveResult-mutated.bc

clang++ -c build-mutation/Board-mutated.bc -o build-mutation/Board.o
clang++ -c build-mutation/SolveResult-mutated.bc -o build-mutation/SolveResult.o

# prevod nemutiranih testova
clang++ -std=c++14 -O0 -g \
  -ISudokuSolver/engine/include \
  -Ibuild/_deps/googletest-src/googletest/include \
  -DSUDOKU_CONTENT_DIR="\"$PWD/SudokuSolver/content/sudokus\"" \
  -DSUDOKU_FIXTURES_DIR="\"$PWD/unit_tests/fixtures\"" \
  -c unit_tests/tests/test_board_load.cpp \
  -o build-mutation/test_board_load.o

clang++ -std=c++14 -O0 -g \
  -ISudokuSolver/engine/include \
  -Ibuild/_deps/googletest-src/googletest/include \
  -DSUDOKU_CONTENT_DIR="\"$PWD/SudokuSolver/content/sudokus\"" \
  -DSUDOKU_FIXTURES_DIR="\"$PWD/unit_tests/fixtures\"" \
  -c unit_tests/tests/test_board_indexing.cpp \
  -o build-mutation/test_board_indexing.o

clang++ -std=c++14 -O0 -g \
  -ISudokuSolver/engine/include \
  -Ibuild/_deps/googletest-src/googletest/include \
  -DSUDOKU_CONTENT_DIR="\"$PWD/SudokuSolver/content/sudokus\"" \
  -DSUDOKU_FIXTURES_DIR="\"$PWD/unit_tests/fixtures\"" \
  -c unit_tests/tests/test_board_solve.cpp \
  -o build-mutation/test_board_solve.o

clang++ -std=c++14 -O0 -g \
  -ISudokuSolver/engine/include \
  -Ibuild/_deps/googletest-src/googletest/include \
  -DSUDOKU_CONTENT_DIR="\"$PWD/SudokuSolver/content/sudokus\"" \
  -DSUDOKU_FIXTURES_DIR="\"$PWD/unit_tests/fixtures\"" \
  -c unit_tests/tests/test_board_print.cpp \
  -o build-mutation/test_board_print.o

clang++ \
  build-mutation/Board.o \
  build-mutation/SolveResult.o \
  build-mutation/test_board_load.o \
  build-mutation/test_board_indexing.o \
  build-mutation/test_board_solve.o \
  build-mutation/test_board_print.o \
  build/lib/libgtest.a \
  build/lib/libgtest_main.a \
  -lpthread \
  -o build-mutation/unit_tests_mutated

./build-mutation/unit_tests_mutated

MULL_CONFIG=mutation-testing/mull.yml \
mull-runner-22 build-mutation/unit_tests_mutated \
  -ide-reporter-show-killed \
  --reporters=IDE \
  --reporters=Elements \
  --report-dir=mutation-testing/report \
  --report-name=sudoku \
  2>&1 | tee mutation-testing/mull-report.txt