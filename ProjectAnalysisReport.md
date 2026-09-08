# Izveštaj analize projekta — SudokuSolver

## Uvod
Cilj rada je praktična primena različitih alata i tehnika za verifikaciju softvera obrađenih na kursu (poput testiranja, statičke analize, profajliranja i drugih pristupa dinamičkoj i statičkoj proveri koda). Kao projekat nad kojim će se demonstrirati korišćenje alata odabran je projekat otvorenog koda - SudokuSolver.

U nastavku izveštaja detaljno su opisani korišćeni alati, način njihove primene, dobijeni rezultati i zaključci izvedeni iz analize.

## 1. Jedinični testovi i pokrivenost koda
### Testiranje
Kao prvi alat korišćen je GoogleTest, za testiranje:
- javnih metoda klase `Board`: `load`,`isSolveable`, `solve`, `print`
- pomoćnih metoda za indeksiranje: `translate`, `getRow`, `getColumn`, `getTileSquare`

Testovi se nalaze u `unit_tests/tests/`, podeljeni po fajlovima:
- `test_board_load.cpp`: učitavanje ispravnog, nepostojećeg fajla, kao i fajla sa belinama i fajla pogrešne dužine
- `test_board_indexing.cpp`: indeksna aritmetika, 
- `test_board_solve.cpp`: rešavanje easy/hard/world_hardest/not_solveable table i provera duplikata u redu koloni/kvadratu 
- `test_board_print.cpp`: ispis table, presretanjem `std::cout`

Za slučajeve kojih nema među gotovim primerima projekta, napravljeni su ručni test fajlovi u `unit_tests/fixtures/`. 

**Rezultat: 17/17 testova prolazi.**

**Napomena**: Tokom pisanja testova za ideksiranje, primetila sam da kompajler prijavljuje upozorenje da su `translate`, `getRow`, `getColumn` i `getTileSquare` deklarisane kao `inline` u `Board.h`, ali im je definicija u `Board.cpp`, a ne u header-u, što tehnički nije ispravno za `inline` funkcije. Build i dalje prolazi jer se linkuje preko `engine` biblioteke, ali je ovo propust u originalnom kodu.

### Pokrivenost koda
Pokrivenost je merena pomocu alata `lcov`. Prilikom generisanja izveštaja javila se greška `(inconsistent) mismatched end line`, zbog novije verzije `gcov`-a koju sam koristila. Ovo sam rešila dodavanjem `--ignore-errors inconsistent` u `run_coverage.sh`.

Pokrivenost `Board.cpp` i `SolveResult.cpp`:
- Board.cpp: **100%**
- SolveResult.cpp: **100%**

Funkcija `Board::print()` nije odmah bila pokrivena nijednim testom, pa sam dodala test koji presreće `std::cout` da proveri ispis.

Reprodukcija:
```bash
./unit_tests/run_tests.sh
./unit_tests/run_coverage.sh
xdg-open unit_tests/coverage/index.html
```