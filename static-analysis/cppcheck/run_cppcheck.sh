#!/bin/bash
set -e
cd "$(dirname "$0")/../.."

mkdir -p static-analysis/cppcheck

cppcheck --enable=all --inconclusive --std=c++14 --force \
  --suppress=missingIncludeSystem \
  -I SudokuSolver/engine/include \
  SudokuSolver/engine/src SudokuSolver/app/src \
  --output-file=static-analysis/cppcheck/report.txt