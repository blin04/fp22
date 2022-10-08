# Liste

## Podudaranje oblika liste


## Izlistavanje


## Funkcije sa rad s listama


### Filter

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

### Map

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

### Zip

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

## Zadaci

Napisati naredne funkcije:

1. Naći poslednji element liste.

2. Naći pretposlednji element liste.

3. Naći broj elemenata u listi

4. Obrnuti listu.

5. Izbaciti iz liste duplikate.

6. Izbaciti iz liste svaki `n` element.

7. Ubaciti dati element na `n`-tu poziciju u listu.
