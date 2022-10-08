# Klase tipova

## Vrste

U prethodnoj sekciji upoznali smo se sa apstraktnim algebarskim tipom podataka

```haskell
data Maybe a = Just a | Nothing
```

Na osnovu prethodne definicje, možemo dobiti tipove poput `Maybe Int`, `Maybe Bool`, `Maybe [Char]`, itd... Međutim, sam `Maybe` ne predstavlja tip sam za sebe (ne postoji vrednost tipa `Maybe`). Šta je onda `Maybe`?

Ako pogledamo bolje, videćemo da `Maybe` od tipova "pravi" nove tipove: od `Int` dobijamo `Maybe Int`, od `[Char]` dobijamo `Maybe [Char]` itd... Prema tome, `Maybe` predstavlja *funkciju nad tipovima* (*tipsku funkciju*). Domen kodomen funkcije nad tipovima je kolekcija svih Haskel tipova. 

Možemo se zapitati koji je tip ove funkcije nad tipovima? Da bismo odgovorili na to, prvo moramo definisati tip tipa.

U Haskelu, tip tipova se naziva *vrsta* (eng. *kind*). Svi konkretni tipovi, tj. oni tipovi koji nisu tipske funkcije (npr. `Int`, `Float`, `Char`, `[Char]`), poseduju vrstu `*`. Za razliku od konkretnih tipova, vrsta `* -> *` tipske funkcije `Maybe` označava da `Maybe` uzima jedan konkretan tip i daje drugi konkretan tip.

U interaktivnom okruženju, vrste tipova možemo saznati uz pomoć naredbe `:kind` (skraćeno `:k`). Na primer

``` 
> :k Int
Int :: *
> :k Maybe
Maybe :: * -> *
> :k Maybe Int
Maybe Int :: *
```

Slično tipu `Maybe`, koristi se i tip `Either`:

```haskell
data Either a b = Left a | Right b 
```

Tip `Either` se često koristi za prezentovanje grešaka i "dobrih" vrednosti. Uobičajno se greške predstavljaju uz pomoć konstruktora `Left`, a "dobre" vrednosti uz pomoć konstruktora `Right`.

Tip `Either` je vrste `* -> * -> *` jer uzima dva konkretna tipa:

```
> :k Either
Either :: * -> * -> *
```

Međutim kada `Either` apliciramo na neki konkretan tip, dobijamo tipsku funkciju jedne promenljive:

```
> :k (Either Int)
(Either Int) :: * -> *
```

Dakle, i na nivou tipova imamo pojmove apstrakcije, aplikacije i karijevanja.

Iako priča o vrstama i tipskim funkcijama deluje apstraktno, mi smo se sa tipskim funkcijama susreli na samom početku učenja Haskela. Tipska funkcija `([]) :: * -> *` prevodi tip `a` u tip lista tog tipa `[a]`. Jedina razlika je u tome što za ovu tipsku funkciju koristimo specijalnu sintaksu (`[a]` a ne `[] a`). Zaista:

```
> :k ([])
([]) :: * -> *
> :k (([]) Int)
(([]) Int) :: *
``` 

*Napomena: ne treba mešati tipsku funkciju `[]` sa konstruktorom prazne liste `[]`*

Još jedna tipska funkcija koja se svuda koristi je `(->) :: * -> * -> *`. Funkcija `(->)` primenjena na dva tipa `a` i `b` daje tip svih preslikavanja iz `a` u `b`. Taj tip označavamo upravo sa `a -> b`.

*Posmatrajući sada tip `Maybe` kroz algebru tipova, shvatamo da `Maybe` odgovara funkciji sledbenika `f(x) = x + 1`. Zaista, funkcija `Maybe` konstruiše novi tip tako što na njega dodaje jednu vrednost.*


## Klase tipova

Klase tipova u Haskelu predstavljaju kolekcije tipova koji imaju neke zajedničke osobine. Te zajedničke osobine izražavaju se kroz funkcije koje je moguće pozivati nad svim tipovima te klase. 

Klasa tipova se definiše narednom konstrukcijom

```haskell
class ImeKlase a where
```

nakon koje sledi niz definicaja tipova nekih funkcija (u ovom slučaju `a` je tipska promenljiva).

Da bi neki tip `T` pridružili klasi tipova `Klasa`, poslužićemo se narednom konstrukcijom

```haskell
instance Klasa T where
```

nakon koje su navedene definicije funkcija koje propisuje klasa.

Više o klasama tipova naučićemo analizirajući neke poznate klase Haskel jezika.

*Napomena: Klasa tipova nema nikakve veze sa pojmom klase u objektno orijentisanim jezicima. Klasa tipova u Haskel jeziku približno odgovara pojmu interfejsa u Javi.*

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

