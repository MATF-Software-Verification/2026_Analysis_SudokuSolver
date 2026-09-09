#!/bin/bash
set -e
cd "$(dirname "$0")"

clang++ -std=c++14 -g -O1 -fsanitize=fuzzer,address \
  -I ../SudokuSolver/engine/include \
  fuzz_board_load.cpp \
  ../SudokuSolver/engine/src/Board.cpp \
  ../SudokuSolver/engine/src/SolveResult.cpp \
  -o fuzz_board_load

DURATION="${1:-120}"
mkdir -p crashes

./fuzz_board_load corpus/ -max_total_time="$DURATION" -artifact_prefix=crashes/