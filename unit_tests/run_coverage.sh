#!/bin/bash
set -e
cd "$(dirname "$0")/.."
rm -rf build-coverage
mkdir build-coverage
cd build-coverage
cmake -DENABLE_COVERAGE=ON ..
cmake --build . -j"$(nproc)"
ctest --output-on-failure

lcov --capture --directory . --output-file coverage.info --base-directory .. \
     --ignore-errors inconsistent
lcov --remove coverage.info '/usr/*' '*_deps/*' '*unit_tests/tests/*' \
     --output-file coverage_filtered.info --ignore-errors inconsistent
genhtml coverage_filtered.info --output-directory ../unit_tests/coverage

echo "Izveštaj: unit_tests/coverage/index.html"