# Parametrizovani tipovi

## Primer: Možda tip

Sada ćemo kreirati tip `MoždaBroj` kojim možemo da predstavimo ili jednu realnu vrednost ili izostanak bili kakve smislene vrednosti (nešto poput vrednosti `null` u javaskriptu). Ovaj tip ćemo konstrusati kao 'uniju' tipova `Float` i jediničnog tipa `Nista` (ništa):

```haskell
data MozdaBroj = SamoBroj Float | Nista 
```

Tip `MozdaBroj` je koristan kad god hoćemo da radimo u programu sa nekim vrednostima koje možda nisu ni zadate. Na primer, ako očitvamo temperaturu s nekog senzora, onda je dobro to očitavanje predstaviti realnom vrednošću. Međutim, u nekim situacijama naš senzor ne mora vraćati očitanu tempraturu (usled nekih hardverskih problema, itd...), i tada treba koristiti specijalnu vrednost koja označava da do očitavanja temperature nije ni došlo. Nezgodno bi bilo koristiti vrednost `0` jer se tada ne mogu razlikovati ispravna očitavanja temerature 0°C od neispravnih (ovo važi i za bilo koji drugi realan broj).

Sa `MozdaBroj` tipom je lako raditi. Na primer ako želimo da računamo apsolutnu razliku dve temperature, možemo napisati ovakvu funkciju

```haskell
apsolutnaRazlika :: MozdaBroj -> MozdaBroj -> MozdaBroj
apsolutnaRazlika (SamoBroj x) (SamoBroj y) = SamoBroj abs(x - y)
apsolutnaRazlika _ _ = Nista
```

Prethodna fuknkcija će vratiti vrednost oblika `SamoBroj i` kad god prosledimo dve vrednosti istog oblika. U svim drugim slučajevima, barem jedna od prosleđenih vrednosti će biti `Nista`, i stoga smisla vratiti samo vrednost `Nista`.

*U Haskelu sa `_` označavamo parametre čija nas vrednost ne interesuje. Znak `_` možemo koristiti na više mesta levo od znaka `=` ali ni jednom desno od znaka `=`.*

Slično tipu `MozdaBroj` možemo konstruisati tip `MozdaNiska`:

```haskell
data MozdaNiska = SamoNiska String | Nista   
```

Jedan od čestih slučajeva u kom bi ovakav tip bio koristan je predstavljanje korisničkog unosa. Na primer, tipom `MozdaNiska` možemo predstaviti adresu korisnika koja potencijalno nije uneta...

Kao što vidimo, konstrukcija tipa je `MozdaNiska` je u potpunosti analogna konstrukciji tipa `MozdaBroj`. I sličnu konstrukciju možemo ponoviti za bilo koji tip.

Ali, da ne bismo istu konstrukciju ponavljali za isti tip, u Haskelu možemo kreirati tip koji zavisi od nekog drugog tipa:

```haskell
data Mozda a = Samo a | Nista
```

U navedenom izrazu, simbol `a` predstavlja proizvoljan tip. U slučaju kada za `a` uzmemo `Float` dobijamo tip identičan `MoždaBroj` tipu, itd... Vidimo da smo sa jednom linijom obuhvatili konstrukciju svih mogućih "moždatipova".

Primer, od malopre, sada bi izgledao ovako

```haskell
apsolutnaRazlika :: Mozda Float -> Mozda Float -> Mozda Float
apsolutnaRazlika (Samo x) (Samo y) = Samo abs(x - y)
apsolutnaRazlika _ _ = Nista
```

"Možda tipovi" su veoma korisni u praksi, zbog čega je u standardnoj Haskell biblioteci definisan tip `Maybe` na već viđen način:

```haskell
data Maybe a = Just a | Nothing
```

Mnoge funkcije koriste *maybe* tipove za povratne vrednosti. Već smo se upoznali sa funkcijom `head :: [a] -> a` koja vraća prvi element liste. Međutim, pozivanje ove funkcije nad praznom listom `[]` dovodi do greške koja prekida izvršavanje programa (izuzetak). Zbog toga, često Haskel programeri koriste funkciju `maybeHead :: [a] -> Maybe a` koja vraća prvi element liste "zapakovan" u `Just` ako ta lista nije prazna, a u suprotnom `Nothing`. Za razliku od funkcije `head`, funkcija `maybeHead` je totalna.

## Vrste

U prethodnoj sekciji upoznali smo se sa apstraktnim algebarskim tipom podataka

```haskell
data Maybe a = Just a | Nothing
```

Na osnovu prethodne definicje, možemo dobiti tipove poput `Maybe Int`, `Maybe Bool`, `Maybe [Char]`, itd... Međutim, sam `Maybe` ne predstavlja tip sam za sebe (ne postoji vrednost tipa `Maybe`). Šta je onda `Maybe`?

Ako pogledamo bolje, videćemo da `Maybe` od tipova "pravi" nove tipove: od `Int` dobijamo `Maybe Int`, od `[Char]` dobijamo `Maybe [Char]` itd... Prema tome, `Maybe` predstavlja *funkciju nad tipovima* (*tipsku funkciju*). Domen kodomen funkcije nad tipovima je kolekcija svih Haskel tipova. Za `Maybe` se često kaže i da je *apstraktan tip* (zato što ne sadrži vrednosti), ili da je *parametrizovani tip* (zato što zavisi od drugog tipa).

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

### Either

Slično tipu `Maybe`, koristi se i tip `Either`:

```haskell
data Either a b = Left a | Right b 
```

Tip `Either` se često koristi za prezentovanje grešaka i "dobrih" vrednosti i u tom smislu predstavlja uopštenje `Maybe` tipa. Uobičajno se greške predstavljaju uz pomoć konstruktora `Left`, a "dobre" vrednosti uz pomoć konstruktora `Right` (najčešće `Right` "sadrži" vrednost tipa `String` koja opisuje grešku).

Apstraktni tip `Either` je vrste `* -> * -> *` jer uzima dva konkretna tipa:

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

### []

Iako priča o vrstama i tipskim funkcijama deluje apstraktno, mi smo se sa tipskim funkcijama susreli na samom početku učenja Haskela. Tipska funkcija `([]) :: * -> *` prevodi tip `a` u tip lista tog tipa `[a]`. Jedina razlika je u tome što za ovu tipsku funkciju koristimo specijalnu sintaksu (`[a]` a ne `[] a`). Zaista:

```
> :k ([])
([]) :: * -> *
> :k (([]) Int)
(([]) Int) :: *
``` 

*Napomena: ne treba mešati tipsku funkciju `([]) :: * -> *` sa konstruktorom prazne liste `[] :: [a]`*

### (->)

Još jedna tipska funkcija koju smo od samog početka koristili je `(->) :: * -> * -> *`. Tipska funkcija `(->)` primenjena na dva tipa `a` i `b` daje tip svih preslikavanja iz `a` u `b`. Taj tip označavamo upravo sa `a -> b`.


## Zadaci

