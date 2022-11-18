# Liste

## Podudaranje oblika liste

Haskel poseduje mogućnost definisanja funkcija preko *podudaranja šablona* (*pattern matching*). Podudaranje šablona dozvoljava da se vrednosti funkcije definišu u zavisnosti od "oblika" argumenta. Tehniku podudaranja šablona je moguće koristiti nad mnogim tipovima (kasnije ćemo videti tačnoi nad kojim), ali je posebno elegnatno koristiti sa listama.

Da bismo definisali funkciju pomoću podudaranja šablona, potrebno je da odmah nakon imena funkcije navedemo šablon koji želimo da "uhvatimo" a zatim i vrednost funkcije za takve argumente. Na primer funkciju tipa `Int -> Int` koja duplira argument možemo ovako definisati:


```haskell
dupliraj :: Int -> Int
dupliraj x = 2 * x
```

U navedenom primeru, `x` predstavlja oblik proizvoljnog broja. Međutim, sa podudaranjem šablona možemo uhvatiti neku konkretnu vrednost. Na primer funkcija `f` koja slika 0 u 1 a sve ostale brojeve u 0, može biti ovako definisana:

```haskell
f :: Int -> Int
f 0 = 1
f x = 0
```

Dakle sa `0` "uhvatili" smo poseban oblik argumenta funkcije. Naravno, istu funkciju smo mogli definisati i uz pomoć *guards* sintakse:

```haskell
f x 
 | x == 0 = 1
 | otherwise = 0
```

Kao i *guards* sintakse, slučajevi se proveravaju redom, odozdo ka dole. Stoga bi naredna funkcija bila konstantna

```haskell
f :: Int -> Int
f x = 0
f 0 = 1
```

Jednostavno rečeno, `x` je "uhvatio" oblik svakog broja. 

Kod brojeva sa podudaranjem šablona moguće je "uhvatiti" samo neke konkretne vrednosti. Međutim, kod lista je moguće uhvatiti razne oblike. 

Na primer funkciju koja proverava da li je lista celih brojeva prazna, možemo definisati

```haskell
empty :: [Int] -> Bool
empty [] = True
empty x = False
```

Slučaj prazne liste je uhvaćen sa oblikom `[]`, dok su svi ostali slučajevi obuhvaćeni generičkim slučajem `x`. Kao i kod *guards* sintakse, neophodno je obuhvatiti sve moguće oblike promenljive. Ako se neki od oblika izostavi, definisana funkcija neće biti totalna, i za neke od argumenata će doći do izuzetka:

```haskell
badEmpty :: [Int] -> Bool
badEmpty [] = True
```

```
> badEmpty [1, 2, 3]
*** Exception: main.hs:3:1-15: Non-exhaustive patterns in function badEmpty
```

Zamislimo sada da želimo da napišemo funkciju `s :: [Int] -> Int` koja praznoj listi dodeljuje `0`, jednočlanoj listi dodeljuje element te liste, dvočlanoj listi dodeljuje zbir dva elementa, a svim ostalim listama dodeljuje `1` (funkcija nema mnogo smisla ali će lepo ilustrovati *pattern matching*). Korišćenjem *guards* sintakse, dobijamo naredni kod


```haskell
s :: [Int] -> Int
s xs 
    | xs == [] = 0
    | len xs == 1 = xs ! 0
    | len xs == 2 = xs ! 0 + xs ! 1
    | otherwise = 1
```

Korišćenjem podudaranja oblika dobijamo elegantniji kod:

```haskell
s :: [Int] -> Int
s [] = 0
s [x] = x
s [x, y] = x + y
s xs = 1
```

Kao što vidimo, podudaranjem oblika *dekonstruisali* smo neke moguće oblike argumenta funkcije. Na primer, u trećoj liniji definisali smo funkcijeu u slučaju kada je njen argument jednočlana lista `[x]`. Imenom `x` ovde smo "vezali" član te jednočlane liste. Slično, u narednoj lini koda, dekonstruisali smo dvočlane liste. U ovom slučaju, prvi element je predstavljen imenom `x` a drugi element imenom `y`. Poslednja linija ne nameće neki specijalan oblik liste. Samo ime, poput `xs`, obuhvata sve oblike lista. 

Moguće je takođe koristi činjenicu da se lista poput `[x, y, z]` može predstaviti kao `x:[y,z]` ili  `x:y:[z]` ili `x:y:z:[]`. Tako je prehodni primer moguće napisati i kao

```haskell
s :: [Int] -> Int
s [] = 0
s x:[] = x
s x:y:[] = x + y
s xs = 1
```

Korišćenje operatora `:` je posebno korisno kada želimo listu podeliti na *glavu* i *rep*, odnosno prvi element i ostatak liste. Na primer, ako želimo da napišemo funkciju `zbir :: [Int] -> Int` koja sabira sve elemete liste, možemo postupiti ovako:

```haskell
zbir :: [Int] -> Int
zbir [] = 0
zbir x:xs = x + zbir xs
```

Gornja funkcija je rekurzivna funkcija koja sabira elemente liste tako što nepraznu listu dekonstuiše na glavu (`x`) i rep (`xs`), a zatim pozove samu sebe za pronalaženje zbira repa. U slučaju prazne vraćamo naravno samo `0`.

## Izlistavanje


## Funkcije sa rad s listama


### `filter`

Funkcija višeg reda `filter` nam omogućuje da iz neke liste izdvojimo samo elemente koji zadovoljavaju neki uslov. Tip ove funkcije je

```haskell
filter :: (a -> Bool) -> [a] -> [a]
```

Prvi argument funkcije je funkcija tipa `a -> Bool`. Ova funkcija treba da vrati vrednost `True` ako element treba da ostane u listi, odnosno `False` ako je element potrebno ukloniti iz liste. Drugi argument funkcije je lista koju filtriramo. Rezultat je prosleđena lista iz koje su uklonjeni elementi koji ne zadovoljavaju predikat.

Na primer, ako želimo da "uzmemo" samo parne projeve iz liste `[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]` možemo napisati naredni program:

```
> filter (\x -> mod x 2 == 0) [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
[2, 4, ,6 , 8, 10]
```

*Neka su `p` i `q` dve funkcije tipa `a -> Bool`. Zašto su `filter p . filter q` i `filter (\x -> p x && q x)` iste funkcije?*

### `map`

Još jedna funkcija višeg reda koja se često koristi sa listama je `map`. Funkcija `map` primenjuje neku drugu funkciju na svaki element liste i vraća listu dobijenih vrednosti. Tip funkcije `map` je:

```haskell
map :: (a -> b) -> [a] -> [b]
```

Prvi argument funkcije je funkcija tipa `a -> b`, a drugi argument je lista tipa `[a]`. Rezultat je lista tipa `[b]` koji je nastao od prosleđene liste primenom prosleđene funkcije na svaki element liste.

Na primer, ako želimo da kvadriramo svaki element liste `[1, 2, 3, 4]`, možemo napisati program 

```haskell
> map (\x -> x ** 2) [1, 2, 3, 4]
[1, 4, 9, 16]
```

*Neka je `f :: a -> b` i `g :: b -> c`. Zašto su `map g . map f` i `map (g . f)` iste funkcije?*

### `foldr` i prijatelji

Funckcije `map` i `filter`, prolaze kroz datu listu primenjujući na svaki element datu funkciju, a zatim vrednosti tih primena koriste za konstruisanje nove liste. Funkcija `foldr` je malo drugačija: ova funkcija koristi prosleđenu binarnu funkciju da bi prosleđenu listu "presavila" (*fold*) u jednu jedinu vrednost (a ne listu). Tip funkcije `foldr` je

```
foldl :: (a -> b -> b) -> b -> [a] -> b
```

Prvi argument funkcije `foldl` je binarna funckija tipa `a -> b -> b`. Drugi argument je početna vrednost, a treći argument je niz koji želimo da "presavijemo". Funkcija `foldr` "prolazi" kroz datu listu s desna na levo (otuda *foldr*) pozivajući nad svakim argumentom datu binarnu funckiju. Za svaki taj poziv, rezultat poziva nad prethodnim argumentom se koristi kao drugi argument binarne funkcije. Inicijalna vrednost se koristi kao drugi argument pri prvom pozivu (a to je poziv nad poslednjim elementom u listi).

Komplikovano objašnjenje će postati jasnije kroz naredni primer. Uz pomoć `foldr` možemo da saberemo sve elemente jedne liste. Definišimo

```haskell
f = \a b -> a + b
```

Ako `foldr` pozovemo nad praznom listom, dobićemo samo inicijalnu vrednost:

```haskell
>foldr f 0 []
0
```

Ako `foldr` pozovemo nad jednočlanom listom, dobićemo rezultat primene funkcije `f` nad jedinim elementom liste i inicijanom vrednošću:

```haskell
> foldr f 0 [1]
1   -- f 1 0 = 1 + 0
```

U slučaju dvočlane liste, funkcija `f` biče dva puta pozvana. Pri drugom pozivu biće iskorišćena povratna vrednost prvog poziva:

```haskell
> foldr f 0 [2, 1]
3   -- f 2 (f 1 0) = f 2 1
```

Za listu od više elemenata imamo:

```haskell
> foldr f 0 [5, 4, 3, 2, 1]
15  -- f 5 (f 4 (f 3 (f 2 (f 1 0))))
```

Prostije rečeno, u ovom slučaju funkcija `foldr` se ponaša tako što postavlja operaciju `+` između svaka dva elementa, asocirajući zagrade ka desno:

```
(5 + (4 + (3 + (2 + (1 + 0)))))
```

Uz funkciju `foldr` koristi se i `foldl` koja "presavija" listu sa leva. Naravno, kada koristimo *komutativnu* operaciju, dobijamo isti rezultat sa `foldl` i `foldr` funkcijama. Ali za nekomutatine operacije, rezultati će se uglavno razlikovati:

```haskell
> g = \a b -> a / b
> foldl g 1 [1, 2, 3]
0.16666 -- (1 / 2) / 3
>foldr g 1 [1, 2, 3]
1.5 -- 1 / (2 / 3)
```

### `zip`

Zip je funkcija koja od dve liste pravi novu listu koju čine uređeni parovi elemenata iz prve dve liste. Pridruživanje se vrši redosledom kojim su elementi navedeni u listama. Tip funkcije `zip` je:

```haskell
zip :: [a] -> [b] -> [(a, b)]
```

Funkciju `zip` ćemo demonstrirati na konkretnom primeru:

```
> zip [1, 2, 3, 4] ['a', 'b', 'c'] 
[(1,'a'),(2,'b'),(3,'c')]
```

Primetimo da je vraćena lista iste dužine kao kraći od prosleđenih lista.

### `zipWith`

Funkcija `zipWith` je upoštenje  prethodno opisane funkcije `zip`. `zipWith` kombinuje dve liste element-po-element koristeći prosleđenu funkciju, te je `zipWith` funkcija višeg reda za razliku od funkcije `zip`. Tip funkicje `zipWith` je:

```haskell
zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
```

Na primer, funkcija `zip` se može definisati preko funkicje `zipWith`:

```haskell
zip = zipWith (\x y -> (x, y))
```

## Zadaci

1. Svi prirodni brojevi manji od 10 koji su deljivi sa 3 ili 5 su 3, 5, 6 i 9. Njihov zbir je 23. Naći zbir svih prirodnih brojeva manjih od 100 koji su deljivi sa 3 ili 5.
2. Palindromski broj je prirodan broj koji se čita isto i sa leva i sa desna. Najveći palindromski broj koji je proizvod dva dvocifrena broja je 9009 (jer je 9009 = 91 x 99). Naći najveći palindromski broj koji je proizvod dva trocifrena broja.
3. Implementirati funkciju koja vraća "Dekartov proizvod dve liste". Na primer: `dekartovProzivod [1, 2, 3] ['a', 'b']` daje `[(1,'a'),(2,'a'),(3,'a'),(1,'a'),(2,'b'),(3,'b')]`.
4. Napisati naredne funkcije:
   1. `last` (vraća poslednji element liste)
   2. `secondToLast` (vraća pretposlednji element liste)
   3. `reverse` (obrće listu)
   4. `unique` (izbacuje duplikate iz liste zadržavajući samo prvi element)
   5. `filter`
   6. `map`
   7. `zip`
   8. `foldl`
   9. `concat` (listu lista spaja u jednu listu)
5. Implementirati `map` funkciju preko `foldl` funkcije.
6. Implementirati `filter` funkciju preko `foldl` funkcije.
7. Naći sve početke data liste. Na primer `poceci [1, 2, 3]` bi trebalo da nam vrati `[[], [1], [1, 2], [1, 2, 3]]`. 
8. Napisati funkciju `kodiraj :: String -> [(Char, Int)]` koja kodira nisku tako što je predstavlja kao niz uređenih parova karatera i prirodnih brojeva. Broj označava dužinu uzastopnog ponavljanja datog karaktera. Na primer: `kodiraj "aaaabb"` daje `[('a', 4), ('b', 2)]`, a `kodiraj "Google"` daje `[('G', 1), ('o', 2), ('g', 1), ('l', 1), ('e', 1)]`. Napisati i funkciju `dekodiraj :: [(Char, Int)] -> String`.
9. Napistai program koji proverava da li je uneti prirodan broj prost.
10. Napisati program koji vraća listu prvih `n` Fibonačijevih brojeva.
11. Napisati funkciju `rotate :: Int -> [a] -> [a]` koja 'rotira' listu tako što svaki element pomera za `n` koraka u levo: `rotate 1 ['a', 'b', 'c', 'd']` daje `['b', 'c', 'd', 'a']`, a rotate `rotate 2 ['a', 'b', 'c', 'd']` daje `['c', 'd', 'a', 'b']`, itd...
