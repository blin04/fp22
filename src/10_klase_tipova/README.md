# Klase tipova


## Klase tipova

Klase tipova u Haskelu predstavljaju kolekcije tipova koji imaju neke zajedničke osobine. Te zajedničke osobine izražavaju se kroz funkcije koje je moguće pozivati nad svim tipovima te klase. 

Klasa tipova se definiše narednom konstrukcijom

```haskell
class ImeKlase a where
```

nakon koje sledi niz definicija tipova nekih funkcija (u ovom slučaju `a` je tipska promenljiva).

Da bi neki tip `T` pridružili klasi tipova `Klasa`, poslužićemo se narednom konstrukcijom

```haskell
instance ImeKlase T where
```

nakon koje su navedene definicije funkcija koje propisuje klasa.


*Napomena: Klasa tipova nema nikakve veze sa pojmom klase u objektno orijentisanim jezicima. Klasa tipova u Haskel jeziku približno odgovara pojmu interfejsa u Javi.*


## Primer: Motorna vozila

TODO


## Predefinsane klase u Haskelu

Više o klasama tipova naučićemo analizirajući neke poznate klase Haskel jezika.

### Klasa `Eq`

U klasi `Eq` (od *equality*) nalaze se svi tipovi koje je moguće porediti pomoću funkcija `==` i `\=`. Definicija klase `Eq` je sasvim jednostavna:

```haskell
class Eq a where
  (==) :: a -> a -> Bool
  (/=) :: a -> a -> Bool
```

Dakle, kao što vidimo, klasa `Eq` propisuje dve binarne funkcije koje vraćaju logičke vrednosti. Te dve funkcije služe za poređenje vrednosti našeg tipa.

Na primer, ako bismo želeli da poredimo vrednosti tipa `Pol` (definisan u ovom gore u ovom tekstu), moramo da definišemo odgovrajuće funkcije `==` i `\=`:

```haskell
instance Eq Pol where
  (==) :: Pol -> Pol -> Bool
  (==) Musko Musko = True
  (==) Zensko Zensko = True
  (==) _ _ = False

  (\=) :: Pol -> Pol -> Bool
  (\=) Musko Musko = False
  (\=) Zensko Zensko = False
  (\=) _ _ = True
```

*Obratite pažnju na nazubljenje. Sve funkcije koje definišete za instancu neke klase, moraju biti uvučene jedan nivo u odnosu na liniju `instance ...`.*

Nako što su funkcije `==` i `\=`, možemo porediti vrednosti tipa `Pol`:

```
> Musko == Zensko
False
```

Primetimo da deluje nepotrebno definisati obe funkcije `==` i `\=`. Zaista, ako bi smo poznavali jednu od ove dve funkcije, bilo bi prirodno da izvedemo onu drugu kao njenu negaciju (ako su dve vrednosti jednake onda nisu različite, i obrnuto). Haskel jezik nam omogućuje i to. Osim što u 'klasi' možemo definisati tipove funkcija, možemo definisati i neke od tih funkcija preko ostalih a zatim nasvesti minimalan skup funkcija koje progrmaer mora definisati za svaku instancu.

Konkretno, puna definicija klase `Eq` je

```haskell
class Eq a where
  (==) :: a -> a -> Bool
  x == y = not (x /= y)
  
  (/=) :: a -> a -> Bool
  x /= y = not (x == y)
```

U prethodinm linijama, vidimo da klasa `Eq` podrazumeva dve funkcije. Svaka od te dve funkcije se može izvesti preko one druge, i u samoj definiciji klase `Eq` su navedena ta izvođenja. Međutim, da se ne bismo vrteli u krug sa definicijama, svaka instanca `Eq` klase mora sadržati barem jednu definiciju funkcija `==` i `\=`. Na primer, za tip `Pol` dovoljno je napisati sledeće

```haskell
instance Eq Pol where
  (==) :: Pol -> Pol -> Bool
  (==) Musko Musko = True
  (==) Zensko Zensko = True
  (==) _ _ = False
```

### Klasa `Ord`

Klasu `Ord` čine svi tipovi koje je moguće porediti pomoću funkcija `<`, `<=`, `>` i `>=`. Definicija klase `Ord` je sledeća:


```haskell
class (Eq a) => Ord a  where
  (<) :: a -> a -> Bool
  (<=) :: a -> a -> Bool
  (>) :: a -> a -> Bool
  (>=) :: a -> a -> Bool
  max :: a -> a -> a
  min :: a -> a -> a
```

Klasa propisuje uobičajne relacije (zapravo funkcije) za poređenje elementa kao i dve binarne funkicje `min` i `max` koje respektivno vraćaju manji odnosno veći od argumenata.

U ovom primeru vidimo nešto drugačiju definiciju klase. Umesto sa `class Ord a where` definicija klase započinje sa `class (Eq a) => Ord a where`. Izraz `(Eq a) =>` *klasno ograničenje*. Klasnim ograničenjima garantujemo da će neki tip pripadati nekoj drugoj klasi pre nego što ga pridružimo ovoj klasi. 

U slučaju klase `Ord` ima smisla zahtevati da tip već pripada klasi `Eq` jer pojam jednakosti vrednosti neophodan za razlikovanje funkcija `>` i `>=`.

Prema tome, klasa (kolekcija tipova) `Ord` je podklasa klase `Eq`.

### Klasa `Show`

Klasu `Show` čine oni tipovi koji se mogu prezentovati u vidu niske: definicija klase `Show` je jednostavna:

```haskell
class Show a where
  show :: a -> String
```

Klasa `Show` je nophodna za ispisivanje vrednosti u `ghci` okruženju.

### Klasa `Num` i `Fractional`

Klasu `Num` čine svi tipovi koji predstavljaju nekakav skup brojeva (celih, racionalnih, realnih, kompleksnih...). Definicija klase `Num` je:

```haskell
class Num a where
  (+) :: a -> a -> a
  (-) :: a -> a -> a
  (*) :: a -> a -> a
  negate :: a -> a
  abs :: a -> a
  signum :: a -> a
```

U ovom slučaju, funkcije su savim jasne.

Klasa `Fractional` je podklasa klase `Num`:

```haskell
class Num a => Fractional a where
  (/) :: a -> a -> a
  recip :: a -> a
```

*`recip` je funkcija koja dodljuje broj njegovu recipročnu vrednost*

Razlika klase `Fractional` u odnosu na klasu `Num` je ta što tipovi klase `Fractional` dozvoljavaju deljenje. Definicije klasa `Num` i `Fractional` približno odgovaraju definicijama *prstena* i *polja*.

