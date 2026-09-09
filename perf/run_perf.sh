#!/bin/bash
set -e
cd "$(dirname "$0")/.."

mkdir -p build-perf
cd build-perf
cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo \
      -DCMAKE_CXX_FLAGS="-fno-omit-frame-pointer" \
      ../SudokuSolver
cmake --build . -j"$(nproc)"
cd ..

mkdir -p perf/perf-outputs
cd build-perf/app

sudo perf record -g -o ../../perf/perf-outputs/anti_backtracking.perf.data \
  -- ./SudokuSolver content/sudokus/anti_backtracking.txt <<< ""

# fajl gore je napravljen od strane root-a (zbog  sudo) 
# vracamo da owner bude user 
sudo chown "$USER":"$USER" ../../perf/perf-outputs/anti_backtracking.perf.data

perf report -i ../../perf/perf-outputs/anti_backtracking.perf.data --stdio \
  > ../../perf/perf-outputs/anti_backtracking.report.txt

echo "Izveštaj: perf/perf-outputs/anti_backtracking.report.txt"