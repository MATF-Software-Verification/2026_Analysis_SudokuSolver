# Analiza projekta SudokuSolver

Seminarski rad u okviru kursa Verifikacija softvera na master studijama Matematičkog fakulteta, Univerziteta u Beogradu

Autor: Luna Rančić  
Broj indeksa: 1027/2025

## Informacije o analiziranom projektu
- Repozitorijum: https://github.com/Seng3694/SudokuSolver
- Grana: master
- Heš komita: cf896c8ac09e9ab831fcf06b478afca78999b2ee
- Opis: Sudoku solver je C++ implementacija rešavača igre Sudoku Zasnovan na backtracking algoritmu.

## Korišćeni alati i zaključci

| # | Alat | Direktorijum | Skripta za reprodukciju | Zaključak
|---|------|--------------|--------------------------|------------|
| 1 | GoogleTest + lcov | `unit_tests/` | `unit_tests/run_tests.sh`, `unit_tests/run_coverage.sh` | prolazi 17/17, 100% pokrivenost `Board.cpp` i `SolveResult.cpp`|
| 2 | libFuzzer | `fuzzing/` | `fuzzing/run_fuzz.sh` | `Board::load()` stabilan na proizvoljan ulaz, nijedan crash  |
| 3 | perf | `perf/` | `perf/run_perf.sh` | `Board::backtrack()` nosi ~99% vremena |
| 4 | Clang Static Analyzer (scan-build) | `static-analysis/scan-build/` | `static-analysis/scan-build/run_scan_build.sh` | nijedan nalaz - očekivano, nema ručne alokacije ni složenih grananja |
| 5 | cppcheck | `static-analysis/cppcheck/` | `static-analysis/cppcheck/run_cppcheck.sh` | 4 nalaza (`functionStatic`, `constVariableReference`) - stilski, bez bagova|
| 6 | clang-tidy | `static-analysis/clang-tidy/` | `static-analysis/clang-tidy/run_clang_tidy.sh` | 109 nalaza, vredni su `bugprone-easily-swappable-parameters` i `bugprone-narrowing-conversions` |
| 7 | Mutaciono testiranje (Mull) | `mutation-testing/` | `mutation-testing/run_mutation.sh` | mutation score [74]% — 100% pokrivenost ne znači jake testove. Pronađene su konkretne rupe (rešenje table se ne validira, brojač backtrack-ova se ne proverava, fixture za duplikat u redu ne izoluje proveru reda) |

