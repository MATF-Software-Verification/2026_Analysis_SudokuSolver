#!/bin/bash
set -e
cd "$(dirname "$0")/../.."

rm -rf build-scanbuild
mkdir -p build-scanbuild static-analysis/scan-build
cd build-scanbuild

scan-build cmake -DCMAKE_BUILD_TYPE=Debug ../SudokuSolver > /dev/null
scan-build -o ../static-analysis/scan-build cmake --build . -j"$(nproc)" \
  2>&1 | tee ../static-analysis/scan-build/scan-build.log

