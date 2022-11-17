# Algebarski tipovi podataka

Već smo uspostavili mnogo analogija između matematičkog pojma *skup* i programerskog pojma *tip*. Na početku kursa smo videli da je sa skupovima moguće vršti neke operacije kao što su presek, unija, Dekartov proizvod itd... Sada ćemo se upoznati sa konstrukcijom novih tiipova u Haskelu. Kao što ćemo uvideti, konstrukcije novih tipova se odvajaju kroz dve "operacije" koje odgovaraju uniji i Dekartovom proizvodu u teoriji skupova.

## Trivijalna konstrukcija

Pre nego što pređemo na sumu i proizvod, pogledajmo jednu trivijalnu konstrukciju. U pitanju je pravljenje novog tipa od već postojćeg tipa.

```haskell
data Temperatura = Temp Int deriving (Show)
```

Navedenom linijom smo konstruisali novi tip `Temperatura`. Svaka vrednost ovog tipa odgovara jednoj vrednosti tipa `Int`. U gornjem izrazu `Temp` je *konstruktor*. Konstruktori su funkcije uz pomoć kojih konstruišemo vrednosti novog tipa. U našem slučaju, konstruktor `Temp` ima tip `Int -> Temperatura`.

Kod `deriving (Show)` nakon definicije tipa nije obavezan. Ovaj kod nam omogućava ispis verednosti definisanog tipa uz pomoć funkcije `show`, što olakšava rad u GHCi-u. Kasnije ćemo detaljnije objasniti `deriving`.

Bitno je da shvatimo da smo navedenim kodom kontruisali jedan tip (kolekciju vrednosti) koju označavamo sa `Temperatura`. Vrednosti koje pripdaju ovom tipu za nas su apstraktni entiteti. Međutim svaku od tih vrednosti možemo dobiti primenom konstruktora `Temp` na neku vrednost tipa `Int`. Zbog toga, tip `Temperatura` možemo da shvatimo kao skup `{... Temp (-3), Temp (-2), Temp (-1), Temp 0, Temp 1, Temp 2, Temp 3 ...}`. Sada. kada znamo da vrednost tipa `Temperatura` mora biti oblika `(Temp x)`, možemo upotrebiti tehniku poklapanja šablona da "oslobodimo" vrednost `x`:

```haskell
uInt :: Temperatura -> Int
uInt (Temp x) = x
```

```
> temperaturaVode = Temp 20
> uInt temperaturaVode
20
```

Ova trivijalna kontrukcija ne deluje previše korisno. Zaista, svo što možemo da uradimo sa vrednostima tipa `Temperatura`, mogli smo već da uradimo sa vrednostima tipa `Int`.

## Proizvod

Proizvod tipova odgovara Dekartovom proizvodu skupova. Proizvod tipova u Haskelu se jednostavno konstruiše: dovoljno je nakon konstuktora navesti više tipova.

Na primer, vektor dvodimenzionalne ravni možemo definsati kao proizvod tipova `Float` i `Float` na sledeći način:

```haskell
data Vektor2D = Vektor Float Float
                deriving (Show)
```

*Nije neophodno da `deriving (Show)` bude u produžetku linije. Ali mora biti u sledećoj liniji.*

Sada ponovo u funkcijama možemo koristiti poklapanje šablona:

```haskell
zbirVektora :: Vektor -> Vektor -> Vektor
zbirVekotra (Vektor x1 y1) (Vektor x2 y2) = Vektor (x1 + x2) (y2 + y2)
```

```haskell
duzinaVektora :: Vektor -> Float
zbirVekotra (Vektor x y) = sqrt (x**2 + y**2)
```

Naravno ne moramo koristiti iste tipove u proizvodu niti ih mora biti samo dva. Sledeći tip prestavlja jednu osobu (njeno ime, godine, i to da li je državljanin Srbije):

```haskell
data Osoba = Osoba [Char] Int Bool
             deriving (Show)
```

Navedeni primer demonstira da je moguće da tip i konstruktor imaju isto ime (ovo se često koristi u Haskel kodovima).

Pri radu sa tipom `Osoba` takođe korsitimo poklapanje šablona. Na primer ako želimo da "izvučemo" ime iz osobe, možemo napisati narednu funkciju:

```haskell
imeOsobe :: Osoba -> [Char]
imeOsobe (Osoba ime _ _) = ime
```

Prethodna funkcija odgovara onome što u objektno orijentisanim jezicima nazivamo *geter* (metoda kojom se pristupa nekom atributu objekta). Lako je implementirati i "seter":

```haskell
promeniIme :: Ime -> Osoba -> Osoba
promeniIme novoIme (Osoba _ godine drzavljanin) = Osoba novoIme godine drzavljanin
```

Pažljiv čitalac će uvideti da smo koncept proizvoda tipova već imali kod uređenih n-torki. I zaista tip `([Char], Int, Bool)` je nekom smislu ekvivalentan tipu `Osoba` (preciznije, između njih postoji bijekcija). Svaku vrednost tipa `Osoba` možemo konvertovati u vrednost tipa `([Char], Int, Bool)` i obrnuto (napišite funkcije koje vrše tu konverziju). Ipak, korišćenje algebarskog proizvoda tipova je više u duhu Haskela. Konstuktori su funkcije, što dozvoljava mnogo veću ekspresivnost (na primer, konstruktore možemo da prosleđujemo funkcijama ili vraćamo od istih, ili da izršimo pracijalnu aplikaciju argumenata).

## Suma

Suma dva tipa `A` i `B` je tip koji sadrži sve vrednosti koje poseduju tipovi `A` i `B`. Suma tipova odgovara uniji dva skupa s tim što se uvek smatra da je ta unija disjunktna.

Suma tipova se vrši postavljanjem vertikalne crte između tipova. Na primer:

```haskell
data SlovoIliBroj = Slovo Char | Broj Int
                    deriving (Show)
```

Ovim smo definisali tip koji možemo da shvatimo kao skup sačinjen od svih slova i brojeva.

Da bi smo radili sa sumama, ponovo ćemo koristiti poklapanje šablona:

```haskell
daLiJeSlovo :: SlovoIliBroj -> Bool
daLiJeSlovo (Slovo x) = True
daLiJeSlovo (Broj x) = False
```

Kao i u slučaju proizvoda tipova, moguće je "sabrati" više tipova od jednom. Na primer sledeći tip označava dužinu u različitim mernim jednicama

```haskell
data Duzina = Metar Float | Milja Float | SvetlosnaSekunda Float
              deriving (Show)
```

Za tip `Duzina` možemo da definišemo ovakvu funkciju konverzije:

```haskell
uMetre :: Duzina -> Duzina
uMetre (Milja x) = Metar (1609.344 * x)
uMetre (SvetlosnaSekunda x) = Metar (299792458 * x)
uMetre x = x
```

Trebalo bi imati na umu da suma tipova uvek shvatamo kao *disjunktnu* uniju. Naredni primer demonstrira ovu činjenicu:

```haskell
data mojBool = Levo Bool | Desno Bool
```

Neko bi možda pomislio da goredefinisan tip `mojBool` sadrži samo dve vrednosti, `True` i `False`,  jer je dobijen uniranjem dva `Bool` tipa. Ipak to nije tako, tip `mojBool` sadrži četiri vrednosti `Levo True`, `Levo False`, `Desno True` i `Desno False`! Dakle, konstruktore možemo shvatiti i kao neke labele koji se dodeljuju konktretnim vrednostima i utiču da se te vrednosti međusobno razlikuju (te stoga `Levo True` i `Desno True` nisu iste vrednosti).

## Jedinični tip

Konstrukcija proizvoda tipova ima oblik `Konstruktor T1 T2 T3 ... Tn`, gde su `T1`, ... `Tn` neki tipovi. U specijalnom slučaju možemo napraviti tip čiji konstruktor ne uzima nijedan dodatni tip:

```haskell
data MojTip = MojKonstruktor
```

U ovom slučaju konstruktor `MojKonstruktor` je funkcija arnosti 0, odnsno konstanta tipa `MojTip`. Drugim rečima, tip `MojTip` sadrži samo jednu vrednost a to je `MojKonstruktor`. Zbog toga za `MojTip` kažemo da je *jediničan tip*.

Ovakva konstrukcija nije mnogo korisna sama po sebi, ali je veoma korisna kada se koristi unutar suma. Na primer, sada lako (i logično) možemo da predstavimo tipove sa konačno mnogo članova (takozvane *enumeracije*):


```haskell
data Pol = Musko | Zensko
```

```haskell
data ZnakKarte = Herc | Karo | Tref | Pik
```

```haskell
data MojeBoje = Crna | Bela | Crvena | Plava | Zelena | Zuta
```

*Napomena: Navedeni tipovi nisu jedinični (npr. `ZnakKarte` sadrži 4 vrednosti), ali su dobijeni sumom jedničnih tipova.*


Zapravo, u Haskelu postoji jedan 'standardan' jediničan tip `()`. Njegova definicija je 

```haskell
data () = ()
```

Ovo je još jedan primer gde konstruktor i tip imaju isto ime.

## Algebra tipova

Na početku kursa smo istakli dve činjenice 

+ Ako su `A` i `B` konačni disjunktni skupovi, tada je `|X ⊔ Y| = |X| + |Y|`. 
+ Ako su `A` i `B` konačni skupovi, tada je `|X × Y| = |X| * |Y|` 

Nije teško uveriti se da ovakve jednakosti važe i za tipove koji imaju konačno mnogo vrednosti. Ovo nagoveštava izvesnu sličnosti između aritmetičkih operacija sabiranja i množenja sa tipskim operacijama sume i proizvoda. Međutim, te sličnosti su mnogo dublje od prostih jednakosti sa kardinalnostima.

Jednakosti sa prirodnim brojevima mogu se često direktno primeniti na tipove. Na primer za prirodne brojeve važi zakon distributivnosti `a * (b + c) = a * b + a * c`. Na jeziku skupova (a samim tim i tipova) navedena jednakost postaje `A × (B ⊔ C) ≅ A × B ⊔ A × C` gde znak `≅` označava da postoji bijekcija između navedenih skupova (ti skupovi nisu *jednaki* ali jesu *izomorfini*).

Navedena jednakost se može lako ilustrovati u Haskelu. Konstruićemo na dva načina tip koji predstavlja osobu, i zatim ćemo uspostaviti bijekciju između ovih tipova

```haskell
-- Tip (B ⊔ C) moramo posebno da definišemo
data Pol = Musko | Zensko
-- A × (B ⊔ C)
data Osoba1 = Osoba1 [Char] Pol

-- A × B ⊔ A × C
data Osoba2 = MuskaOsoba [Char] | ZenskaOsoba [Char]

konvertuj1 :: Osoba1 -> Osoba2
kovertuj1 (Osoba1 x Musko) = MuskaOsoba x
kovertuj1 (Osoba1 x Zensko) = ZenskaOsoba x

konvertuj2 :: Osoba2 -> Osoba1
konvertuj2 (MuskaOsoba x) = Osoba1 x Musko
konvertuj2 (ZenskaOsoba x) = Osoba1 x Zensko
```

Sve jedno je da li koristimo tip `Osoba1` ili tip `Osoba2` za prezentovanje osobe. Bitno je da znamo da nijedna od ove dve prezentacije nije suštinski bolja od one druge.

Analogije postoje između broja `1` i tipa `()` (ili bilo kog drugog jediničnog tipa). Na primer u aritmetici važi `m * 1 = m`. Na jeziku skupova (i tipova) ta jednakost postaje `A × () ≅ A`. Zaista, množenjem nekog tipa sa jediničnim tipom, suštinski ne dobijamo novi tip:

```haskell
data Tip = Tip Int ()

uTip :: Int -> Tip
uTip x = Tip x ()

uInt :: Tip -> Int
uInt (Tip x _) = x
```

Ovim je demonstrirano da `Int × () ≅ Int`.

## Primer: Možda tip

Sada ćemo kreirati tip `MoždaBroj` kojim možemo da predstavimo ili jednu realnu vrednost ili izostanak bili kakve smislene vrednosti (nešto poput vrednosti `null` u javaskriptu). Ovaj tip ćemo konstrusati kao 'uniju' tipova `Float` i jediničnog tipa `Nista` (ništa):

```haskell
data MozdaBroj = SamoBroj Float | Nista 
```

Ovaj tip je koristan kad god hoćemo da radimo u programu sa nekim vrednostima koje možda čak nisu ni zadate. Na primer, ako očitvamo temperaturu s nekog senzora, onda je dobro to očitavanje predstaviti realnom vrednošću. Međutim, u nekim situacijama naš senzor ne mora vraćati očitanu tempraturu (usled nekih hardverskih problema, itd...), i tada treba koristiti specijalnu vrednost koja označava da do očitavanja temperature nije ni došlo. Nezgodno bi bilo koristiti vrednost `0` jer se tada ne mogu razlikovati ispravna očitavanja temerature 0°C od neispravnih (ovo važi i za bilo koji drugi realan broj).

Sa "možda" tipom je lako raditi. Na primer ako želimo da računamo apsolutnu razliku dve temperature, možemo napisati ovakvu funkciju

```haskell
apsolutnaRazlika :: MozdaBroj -> MozdaBroj -> MozdaBroj
apsolutnaRazlika (SamoBroj x) (SamoBroj y) = SamoBroj abs(x - y)
apsolutnaRazlika _ _ = Nista
```

Prethodna fuknkcija će vratiti vrodnost oblika `SamoBroj i` kad god prosledimo dve vrednosti istog oblika. U svim drugim slučajevima, barem jedna od prosleđenih vrednosti će biti `Nista`, i stoga smisla vratiti samo vrednost `Nista`.

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

## Zadaci

1. Kreirati algebarski tip podataka `Vektor` koji predstavlja vektor u trodimenzionalnom prostoru (Koristiti `Float` tip za koordinate). Kreirati funkcije za sabiranje vektora, množenje vektora skalarem, skalarnog množenja vektora, vektorskog množenja vektora i računanja dužine vektora.

2. Kreirati algebarski tip `Valuta` koji može da predstavi neke valute (npr, RSD, EUR, USD) i funkcije koje vrše koverziju između ovih valuta. Kreirati algebarski tip `Svota` koji sadrži jednui vrednost tipa `Float` i vrednost tipa `Valuta`. Kreirati algabarski tip `Banka` koji predstavlja nekoliko domaćih banaka. Kreirati tip `Racun` koji sadži vrednost tipa `Int` (broj računa) i vrednost tipa `Banka` (predstavlja banku u kojoj je otvoren račun). Tip `Racun` se koristi samo za identifikaciju, i nema u sebi podatke o promeni računa. Kreirati algebarski tip `Transakcija` koji sadrži vrednost tipa `Svota`, a zatim dve vrednosti tipa `Racun` koje predstavljaju račun sa kog se šalje odnosno na koji se šalje novac. Kreirati jedan proizvoljan niz `Transakcija` od 5 članova ili više. Kreirati funkciju `promenaNaRacunu:: Racun -> Transakcija -> Svota` koja računa promenu stanja računa nakon svih izvršenih transakcija. Pretpostaviti da račun može da prime svote novca u bilo kojoj valuti. Krajnju promenu iskazati u evrima. [*Rešenje*](./02.hs)

3. Kreirati tip `Tacka` koji predstavlja tačku u dvodimenzionalnoj ravni. Kreirati tip `Figura` koji može da predstavi pravugaonik, krug, trougao, i proizvoljni pravilni mnogougao u ravni. Kreirati funkcije `povrsina :: Figura -> Float` i `obim :: Figura -> Obim` koje redom računaju površinu i obim figura. Kreirati funkciju `transliraj :: (Float, Float) -> Figura -> Figura` koja translira (pomera) figuru. Kreirati funkciju `skaliraj ::  Float -> Figura -> FIgura` koja [skalira](https://en.wikipedia.org/wiki/Homothety) figuru za uneti faktor.

4. Kreirati tip `KompleksanBroj`. Implemenitari funkcije koje sabiraju, oduzimaju, množe i dele kompleksne brojeve.

5. Kreirati tip `Matrica` koji predstavlja matricu dimenzija 3x3. Kreirati funkcije koje sabiraju matrice, skalirraju matricu, i računaju determinantu matrice. Kreirati tip `Vektor` koji predstavlja vektor trodimenzionalno prostora. Kreirati funkciju koja množi matricu i vektor.

6. Koji je pandan zakonu komutativnosti `m * n = n * m` na jeziku tipova? Kako bi ste tu jednakost iskazali u Haskelu?
