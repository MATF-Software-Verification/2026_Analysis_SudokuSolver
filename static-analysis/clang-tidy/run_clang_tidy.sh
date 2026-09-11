#!/bin/bash
set -e
cd "$(dirname "$0")/../.."

mkdir -p build-tidy static-analysis/clang-tidy
cd build-tidy
cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DCMAKE_BUILD_TYPE=Debug ../SudokuSolver > /dev/null
cmake --build . -j"$(nproc)" > /dev/null
cd ..

clang-tidy -p build-tidy \
  --config-file=static-analysis/clang-tidy/.clang-tidy \
  SudokuSolver/engine/src/Board.cpp \
  SudokuSolver/engine/src/SolveResult.cpp \
  SudokuSolver/app/src/Main.cpp \
  > static-analysis/clang-tidy/report.txt 2>&1