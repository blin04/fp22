# Tipovi

Iako smo do sada u par navrata spomenuli izraz *tip*, nismo još naveli šta je to tačno tip. Dajemo narednu jednostavnu definicju:

> Tip je kolekcija vrednosti.


Na primer tip `Bool` je kolekcija koja sadrži samo dve vrednosti: `True` i `False`, dok tip `Int` sadrži sve označene celobrojne brojeve koji se mogu izraziti u procesorskoj reči, odnosno u 64 bita.

Važno je znati da u Haskelu svaki izraz ima tip, odnosno, pripada nekakvoj kolekciji vrednosti. Imena svih (konkretnih) tipova u Haskelu počinju velikim slovom (i obrnuto je skoro tačno. Sve što počinje velikim slovom je uglavnom vezano za tipove).

Kao što smo na početku napisali, Haskel jezik ima jak sistem tipova. Preciznije, Haskel poseduje *statički sistem tipova* što znači da su tipovi svih izraza poznati prilikom kompilacije. To je dobro jer se time otklanjaju mnoge greške koje bi mogle srušiti ceo program prilikom izvršavanja (na primer GHC neće iskompajlirati program u kom se neki broj deli sa nekom niskom jer takva operacija nema smisla). Jezici poput *Pyhon*-a i *JavaScript*-a  nemaju statički sistem tipova, već *dinamički* sistem tipova. U takvim jezicima, često se dešavaju greške (bagovi) koje su nastale samo zato što tipovi nisu bili odgovarajći.

Još jedna karkteristika koja odlikuje Haskelov sistem tipova je *zaključivanje tipova*. Dok je u jezicima poput C-a ili Jave neophodno navesti tip svake pormenljive ili funkcije, Haskel kompajler skoro uvek može zaključiti tip izraza bez potrebe da programer to navede. Po ovome se Haskel značajno razlikuje od ostalih jezika sa statičkim sistemom tipova. Statički tipizirani jezici poput Jave i *C++*-a zahtevaju od programera da napiše značajno mnogo koda koji se odnosi na tipove. Za razliku od tih jezika, zaključivanje tipova u Haskelu nam je omogućilo da u prethodnoj sekciji napišemo neke Haskel programe bez posvećivanja mnogo pažnje tipovima. Ipak, tipovi čine značajan deo Haskel jezika, i neophodno je razumeti ovaj sistem. 

## Osnovi tipovi

Kao što smo rekli, u Haskelu svaki izraz poseduje tip. Taj tip možemo saznati u interaktivnom okruženju uz pomoć komande `:type` (skraćeno `:t`):

```
> :t True
True :: Bool
```

```
> :t 'a'
'a' :: Char
```

```
x = True
> :t x
x :: Bool
```

Kao što vidimo, potpis tipa se sastoji od imena ili vrednosti izraza, nakon čega sledi `::` sa imenom tipa.

**Napomena**: ako pokušate da pronađete tip nekog broja (npr. `2`) iznenadiće vas tip `2 :: Num p => p` (umesto očekivanog `Int` na primer). Uskoro ćemo objasniti ovu notaciju, a do tada ćemo baratati samo sa tipovima poput `Char` i `Bool`. 

Na prethodnom predavanju, videli smo kako možemo da konstruišemo neke nove tipove podataka od postojećih. Konkretno, prikazali smo kako možemo konstruisati liste i uređene n-torke. Pogledajmo potpise ovih tipova.

Ako je `a` neki tip, tada sa `[a]` označavamo tip svih lista sačinjenih od vrednosti tipa `[a]`:

```
> :t [True, False, False, True]
[True, False, False, True] :: [Bool]
```

```
> :t "Hello World!"
"Hello World" :: [Char]
```

```
> :t [[True], [], [True, False]]
[[True], [], [True, False]] :: [[Bool]]
```

Tip uređene n-torke je uređena n-torka odgovarajućih tipova:

```
> :t ('a', True)
('a', True) :: (Char, Bool)
```

```
> :t ('a', 'b', 'c')
('a', 'b', 'c') :: (Char, Char, Char)
```

Posmatrano kroz teoriju skupova, tip poput `(Char, Bool)` odgovara Dekartovom proizvodu skupova `Char` i `Bool` tj `Char ⨯ Bool`. Slično važi i za uređene trojke, četvorke itd...

## Tip funkcije

Rekli smo na početku da svi izrazi u Haskel jeziku poseduju tip. Do sada smo ispitali tipove nekih konstanti, a sada ćemo pogledati tip funkcija. 

Definišimo funkciju `uSlovo` koja logičkim vrednostima dodeljuje jedan karakter:

```haskell
uSlovo x
	| x == True  = 'T'
	| x == False = 'N'
```

*Navedena funkcija se može malo elegantnije (kraće) definisati. Možete li da napišete tu definiciju?*

Tip ove funkcije možemo lako pronaći:

```
> :t uSlovo
uSlovo :: Bool -> Char 
```

Tip `Bool -> Char` nam govori da se radi o funkciji koja preslikava vrednosti tipa `Bool` u vrednosti tipa `Char`. Primetimo da je ova oznaka analogna oznaci koju koristimo u matematici za označavanje tipova. U matematici bismo pisali `f: A → B`, dok u Haskelu pišemo `f :: A -> B`.


Kog tipa je naredna funkcija od dve promenljive?

```haskell
nili x y = not x && not y
```

```
> :t nili
nili :: Bool -> Bool -> Bool
```

Za razliku od lambda izraza za koje je važilo pravilo levo asocijativnosti aplikacije, simbol `->` u tipovima je desno asocijativan. Stoga izraz `Bool -> Bool -> Bool` treba tumačiti kao `Bool -> (Bool -> Bool)`.

Šta nam tip `Bool -> (Bool -> Bool)` govori? Funkcija `nili` preslikava vrednost tipa `Bool` u funkciju tipa `Bool`, a to je upravo karijevanje koje smo definisali u lambda računu. 

Funkciju `nili` smo mogli da definišemo i na uređenim parovima tipa `(Bool, Bool)` kao `nili par = not (fst par) && not (snd par)`. U tom slučaju tip funkcije `par` bi bio `(Bool, Bool) -> Bool`, što znači da ne bismo radili sa karijevanom funkcijom već funkcijom koja uređene parove preslikava u `Bool`.

Ovo samo demonstrira činjenicu koju smo već znali, da se svaka karijevana funkcija može predstaviti kao funkcija čiji je domen Dekartov proizvod `n` skupova, ali i obrnuto (npr. funkcija tipa `A1 -> A2 -> ... -> An -> B` može se predstaviti kao funkcija `(A1, A2, ..., An) -> B`).

Primetimo jednu očiglednu činjenicu. Primenom (aplikacijom) funkcije tipa `A -> B` na vrednost tipa `A` dobijamo vrednost tipa `B`. Neformalno govoreći, možemo da kažemo da aplikacijom brišemo prvu levu strelicu.

Primenom funkcije `f` tipa `A1 -> A2 -> ... -> An -> B` na vrednost tipa `A1` dobijamo novu funkciju tipa `A2 -> A3 -> ... -> An -> B`. Sada novodobijenu funkciju možemo primeniti na vrednost tipa `A2` i time dobiti funkciju tipa `A3 -> ... -> An -> B`. Ovaj postupak se može ponavljati sve dok ne stignemo do vrednosti tipa `B`.

### Navođenje tipova

Haskel kompajler je u prethodnim primerima ispravno zaključio tip funkcije jer smo bili oprezni da dobro definišemo funkciju. Ako samo malo promenimo definiciju naše funkcije i pokušamo da tu definiciju učitamo u interaktivno okruženje, dobićemo grešku

```haskell
uSlovo x
	| x == True  = 'T'
	| x == 2 = 'N'
```

```
> :l main.hs
[1 of 1] Compiling Main             ( main.hs, interpreted )

main.hs:3:11: error:
    • No instance for (Num Bool) arising from the literal ‘2’
    • In the second argument of ‘(==)’, namely ‘2’
      In the expression: x == 2
      In a stmt of a pattern guard for
                     an equation for ‘uSlovo’:
        x == 2
  |
3 |    | x == 2 = 'N'
  |           ^
```

Gornja greška je nastala jer ne postoji tip koji istovremeno sadrži vrednosti `True` i `2`. 

Da bismo izbegli ovakve greške, od sada pa nadalje ćemo uvek navoditi tip funkcije pre definicije. Na primer, prethodni primer sada izgleda ovako

```haskell
uSlovo :: Bool -> Char 
uSlovo x
	| x == True  = 'T'
	| x == False = 'N'
```

Na ovaj način govorimo GHC kompajleru kog je tipa naša funkcija.


### Prefiksna i infiksna notacija

U matematici primena funkcije na vrednost se označava tako što se ime funkcije napiše ispred te vrednosti koja je postavljena u zagrade (npr. `f(2)`). Slično je i u lambda računu s tim što se zagrade oko argumenta izostavljaju (prethodni primer bi se zapisao `f 2`). Ovaj način zapisivanja funkcija nazivamo *prefiksna* notacija.

Prefiksna notacija se koristi i za funkcije više argumenta, pa se tako piše `f(2, 8.9)` itd... U slučaju funkcija dva argumenta osim prefiksne notacije moguće je primenu funkcija na vrednosti zapisati uz pomoć *infiksne* notacija. U infiksnoj notaciji, ime funkcije se zapisuje između dve vrednosti na koje se funkcija primenjuje.

Infiksnu notaciju koristimo svakodnevno. Na primer, operacija sabiranja je funkcija od dva argumenta koju uvek zapisujemo infiksno (`x + y` umesto `+(x, y)`). Slično važi i za ostale aritmetičke operacije.

Haskel dozvoljava infiksni zapis funkcija dva argumenta. Jedini uslov je da ime funkcije bude sačinjeno od simbola poput `<>+*#@...`. Primer za to su aritmetičke i logičke operacije. U to se možemo lako uveriti:

```
> :t (&&)
(&&) :: Bool -> Bool -> Bool
```

U slučaju kada ispitujemo tip "infiksne funkcije" moramo da koristimo zagrade da bi kompajler dobro parisirao izraz. Zapravo, zagrade služe da bi se od "infiksne funkcije" dobila "prefiksna funkcija". Na primer

```
> (+) 2 6
8
```

```
> (||) True False
True
```

Često je zgodno učiniti i suprotno, od prefiksne funkcije *ad-hoc* napraviti infiksnu funkciju. To možemo učiniti tako što ćemo ime funkcije navesti između navodnika \`\`. Na primer, funkciju `nili` možemo ovako koristiti u infiksnom zapisu

```
> True `nili` False
False
```

Mogućnost lakog definisanja infiksnih funkcija dodatno utvrđuje činjenicu da je u Haskelu pojam funkcije postavljen na prvo mesto.


## Zadaci

1. Naći tipove narednih izraza. Proveriti rešenje uz pomoć `ghci`-a.

+ `[True, False, True]`
+ `["True", "False", "True"]`
+ `[(1 :: Int, 2 :: Float), (3, 4), (5, 6), (7, 8)]`
+ `([True, False, True, False], False)`
+ `[("True", 10 :: Int), ("False", 0), ("Maybe", 5)]`
+ `True || False`
+  `2 <= 3`
+ `head [(1 :: Int, "Pas"), (2, "Mačka"), (3, "Papagaj")]`
+ `[2^9, 3 * 17, 5, 19] <= [8^3, 17 * 3, 2 * 2 + 1, 19]`

2. Napisati funkcije koje imaju sledeće tipove

+ `a -> a`
+ `a -> b -> a`
+ `a -> b -> [a]`
