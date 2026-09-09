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

## Fuzz testiranje (libFuzzer)

Kao drugi alat u analizi korišćen je **libFuzzer**, coverage-guided fuzzer koji dolazi uz Clang. 
Fuzzing, za razliku od jediničnih testova, sam generiše veliki broj nasumičnih ulaza i prati koje linije koda su pogodili. 
Kad naiđe na ulaz koji otkrije neki novi deo koda, dalje ga izmenjuje taj ulaz.

Testirana je funkcija `Board::load()`, jer je to jedino mesto u programu gde ulazi  potencijalno nepouzdan podatak, tj. sadržaj fajla koji korisnik zada programu. 
Sve ostalo u kodu radi nad podacima koji su već prošli kroz `load()`, pa se pretpostavlja da su validni.

Pošto `load()` prima putanju do fajla, a ne sirove bajtove, napisan je mali harnes (`fuzzing/fuzz_board_load.cpp`) koji upisuje fuzz ulaz u privremeni fajl i tek onda poziva `load()` nad njim (ne dira se originalni kod).  
Harnes je kompajliran sa `-fsanitize=fuzzer,address`, gde `fuzzer` ubacuje sam libFuzzer engine, a `address` (AddressSanitizer) hvata memorijske greške (npr. čitanje van granica niza) čim se dese, ne nakon pada programa.

Kao seed korpus (početni primeri od kojih fuzzer kreće mutacije) korišćeni su  gotovi primeri `SudokuSolver/content/sudokus/`.

### Rezultat
Prvo je pokrenut kratak probni run (60s) kako bih potvrdila da harnes radi ispravno:  
`#153005 DONE   cov: 387 ft: 1269 corp: 121/9114b lim: 1026 exec/s: 2508 rss: 466Mb`  

Nakon toga, ponovo sam pokrenula, ali u trajanju od 30 minut (1800s):  
`#4209181        DONE   cov: 387 ft: 1275 corp: 112/8576b lim: 4096 exec/s: 2337 rss: 471Mb`


* Oba pokretanja bila su bez ijednog crash-a ili ASan greške
* Pokrivenost (`cov`) je ostala na 387 linija u oba run-a
* Broj features je malo porastao (ft: 1269 -> 1275), što znači da je duži run otkrio neku dodatnu putanju kroz kod

**Reprodukcija**
```bash
./fuzzing/run_fuzz.sh 60      
./fuzzing/run_fuzz.sh 1800    
```

**Zapanimljivost** Tokom dužeg run-a, libFuzzer je sačuvao jedan "spor" ulaz (`fuzzing/slow-unit-1286b4e7f143cc814ffc44c392d576b23e0fd5b8`), tj. taj ulaz je u jednom trenutku obrađen sporije nego ostali u tom momentu, pa ga je libFuzzer automatski izdvojio. Kada sam taj isti fajl pokrenula zasebno ponovo izvršio se za 3ms. To znači da usporenje nije bilo zbog problema u kodu, već verovatno zbog opterećenja sistema. 

### Zaključak
`Board::load()` je stabilan na proizvoljan ulaz, na osnovu toga što se nije desio nijedan crash ni ASan greška u velikom broju pokušaja.  
Jedini sumnjiv nalaz (spor ulaz) se pri proveri pokazao kao lažna uzbuna, a ne stvaran problem u kodu.

