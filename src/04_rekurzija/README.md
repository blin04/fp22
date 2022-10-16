# Rekurzija


Rekurzija je način rešavanja nekog programerksog problema korišćenjem rešenja istog problema manje složenosti (dimenzije, veličine). To u praksi znači da rekurzivna implementacija algoritma podrazumeva (direktno ili indirektno) samopozivanje funkcije sa promenejenim argumentima. Moć rekurzije leži u tome što se rešenja teških problema mogu iskazatu kroz jednostavne veze. 

## Primeri

U nastavku ćemo kroz neke klasične primere videti kako možemo implementirati rekurziju u Haskelu. Primer su poređani od jednostavnijih ka složenijim, i demonstriraju različite oblike rekurzije. Neke druge rekurzivne tehnike ćemo upoznati kasnije kroz Haskel.

### Aritmetička suma

> Napisati funkciju `zbir` koja vraća zbir prvih `n` prirodnih brojeva. Na primer, `zbir 1 = 1`, `zbir 2 = 3`, `zbir 3 = 6`, itd...  

Funkciju `zbir` je lako implementirati u nekom imperativnom jeziku pomoću jedne petlje. Međutim, u Haskelu  ne postoji pojam petlje, te moramo iskoristiti tehniku rekurzije. Kao što smo napomenuli, to podrazumeva da pri nalaženju rešenja, koristimo rešenje istog problema manje složenosti. Konkretno u ovom slučaju to znači da prilikom nalaženja zbira brojeva koristimo neki manji zbir. Ako šematski prikažemo zbir, rešenje će nam se samo ukazati:

```
zbir n = 1 + 2 + ... + (n-1) + n 
```

Kao što vidimo, u zbiru prvih `n` prirodnih brojeva, pojavljuje se zbir prvih `n - 1` brojeva. Stoga važi naredna veza:

```haskell
zbir = \n -> zbir (n - 1) + n 
```

Dakle da bismo izračunali, na primer, zbir prvih 5 prirodnih projeva, izračunaćemo prva 4 broja i dodati 5 na taj zbir. Međutim, da bismo izračunali zbir prva 4 prirodna broja, izračunaćemo zbir prva tri prirodna broja i dodati 4 na taj zbir, itd.. U jednom trenutku ćemo stići do toga da nam je potreban zbir jednog broja. U tom slučaju, nećemo više koristiti vezu koju smo opisali, već ćemo prosto vratiti `1`. Takav slučaj, slučaj u kom ne koristimo rekurzivnu definiciju, nazivamo *bazni slučaj*.

Dakle, kompletna funkcija za računanje zbira prvih `n` brojeva može se ovako zapisati u Haskelu:

```haskell
zbir n
    | n == 1 = 1
    | otherwise  = zbir (n - 1) + n
```

*Ovde možete i koristiti `if then else` notaciju da bi ste definisali `zbir` u jednoj liniji.*

Uverimo se da program zaista dobro radi:

```haskell 
zbir 5 = zbir (5 - 1) + 5
       = (zbir 4) + 5
       = (zbir (4 - 1) + 4) + 5 
       = ((zbir 3) + 4) + 5
       = (((zbir (3 - 1)) + 3) + 4) + 5
       = (((zbir 2) + 3) + 4) + 5
       = (((zbir (2 - 1) + 2) + 3) + 4) + 5
       = ((((zbir 1) + 2) + 3) + 4) + 5
       = ((((1 + 2) + 3) + 4) + 5
```

### Faktorijel

U matematici, faktorijel prirodnog broja `n` predstavlja proizvod svih prirodnih brojeva manjih ili jednakih sa `n`. Faktorijel broja `n` obeležavamo sa `n!`, Prema tome:

```
n! = 1 ⋅ 2 ⋅ 3 ⋅ ... ⋅ (n-1) ⋅ n
```

Ovde možemo primetiti da se `n!` može izračunati kao proizvod `(n - 1)!` sa `n`. Postupajući kao u prethodnom primeru dobijamo sledeći Haskel kod:

```haskell
faktorijel n
    | n == 1 = 1
    | otherwise = faktorijel (n - 1) * n
```

Ipak, postoji jedan mali problem sa konstruisanom funkcijom: ako bismo potražili `faktorijel (-3)`, funkcija bi ušla u *beskonačnu rekurziju*. Zaista, za računanje vrednosti `faktorijel (-3)` bilo bi potrebno izračunati `faktorijel (-4)`, a za `faktorijel (-4)` bi bilo potrebno izračunati `faktorijel (-5)`, i tako u nedogled. Da bismo sprečili beskonačnu rekurziju, za sve brojeve `<= 0`, vratićemo `1` kao rezultat. Stoga definišemo funkciju `faktorijel'` koja je totalna (definisana je za sve vrednosti domena):

```haskell
faktorijel' n
    | n <= 0 = 1
    | otherwise = faktorijel' (n - 1) * n
```

Primetimo da se ova definicja slaže sa prethodnom, jer je sada `faktorijel' 1 = (faktorijel' 0) * 1 = 1 * 1 = 1 = faktorijel 1`. Jedino po čemu se razlikuju funkcije `faktorijel` i `faktorijel'` je to što `faktorijel` nije defininisana za brojeve `<1`. Za razliku od toga `faktorijel'` za te brojeve vraća vrednost `1`.

Opisani porblem postoji i sa funkcijom `zbir` iz prethodnog primera, i i tu se može razrešiti na isti način.

### Fibonačijev niz

Fibonačijev niz je dobro poznati niz pridonih brojeva, koji se kontruiše po sledećem prinicpu:

> Prva dva člana Fibonačijevog niza su `1` i `1`. Svaki naredni član Fibonačijevog niza je zbir prethodna dva člana.

Po navedenom principu, treći član Fibonačijevog niza je `2` (jer je `2 = 1 + 1`), četvrti član je `3` (jer je `3 = 1 + 2`), peti član je `5` (jer je `5 = 2 + 3`), šesti član je `8` (jer je `8 = 3 + 5`), i tako dalje...

Konstrisanje Haskel funkcije `fib` koja za prosleđeni argument `n` vraća n-ti Fibonačijev broj je neznatno složenije nego što su bili prethodni primeri. U ovom slučaju vrednost `fib n` zavisi od `fib (n - 1)` i `fib (n - 2)`. Zbog toga, potrebno je  definisati dva bazna slučaja `fib 1`, i `fib 2`. Samo ako su definisana obe ove vrednosti, moguće je izračunati `fib 3`, a saimim tim i `fib 4`, i `fib 5`, itd...

```haskell
fib n
    | n == 1 = 0 
    | n == 2 = 1
    | otherwise = fib (n - 1) + fib (n - 2)
```

*Napomenimo da aplikacija argumenta ima veću prioritet od aritmetičkih operacija, te se `fib (n - 1) + fib (n - 2)` interpretira kao `(fib (n - 1)) + (fib (n - 2))`. Iz istog razloga ne možemo pisati samo `fib n - 1 + fib n - 2`, jer bi se to interpretiralo kao `(fib n) - 1 + (fib n) - 2`*

Ponovo imamo funkciju koja nije totalna, ali lako možemo dodefinisati vrednosti za brojeve `<= 0`:

```haskell

fib n
    | n <= 1 = 0
    | n == 2 = 1
    | otherwise = fib (n - 1) + fib (n - 2)
```

### Vavilonsko korenovanje

Kao što znamo koren pozitivnog broja `s`, u oznaci `√s`, je pozitivan broj koji kada se kvadrira daje broj `s`. Iako je kvadriranje trivijalna aritmetička operacija, i za ljude i za računara, nalaženje korena nije. Vremenom je razvijeno mnogo metoda za računanje, najstariji je verovatno onaj koji je opisao starogrčki matematičar Heron. Ipak, ovaj metod se često prepisuje matematičarima starog Vavilona. Metod se sastoji u tome da se konstuiše niz brojeva `x₀`, `x₁`, `x₂`, .... `xₙ` koji teže ka broju `√s`. Postupak je sledeći:

1. Za `x₀` uzeti pozitivan broj strogo manji od `s` (npr. `s/2`).
2. Izračunati član `xₙ₊₁` kao aritmetičku sredinu brojeva `xₙ` i `s/xₙ`.
3. Korak 2 ponavaljati dok se ne dostigne zadovoljavajuća tačnost.

Osnovna ideja iza ovog algoritma, je ta da ako je `x` veće od `√s`, tada je `s/x` manje od `√s`, te je stoga aritmetička sredina `x` i `s/x` bolja aproksimacija za `√s` od `x`. Analogno važi i ako je `x` manje od `√s`.


Mi možemo pretpostaviti da `x₁₀` dovoljno preciznu aproksimaciju. Stoga možemo napisati funkciju `koren` koja broju `s` dodeljuje `x₁₀`. Sam niz `x₀`, `x₁`, `x₂`, .... `x₁₀` izračunaćemo rekurzivno uz pomoć funkcije `x` koja uzima dva parametra: prvi parametar predstavlja indeks `n`, dok je drugi parametar `s`, i vraća `xₙ`. 

``` haskell
x n s
 | n <= 0 = s / 2
 | otherwise = (x (n - 1) s + s / x (n - 1) s)
```

Dakle, za `n = 0` vraćamo prvu aproksimaciju `x₀` za koju smo rekli da je `s / 2` (zapravo, ovde ponovo stavljamo uslov `n <= 0` da ne bismo imali problema sa negativnim brojevima). Za svako drugo `n` vraćamo `xₙ` kao aritmetičku sredinu od `xₙ₋₁` i `s/xₙ₋₁`.

Sada funkciju `koren` možemo da definišemo kao

```
koren = \s -> x 20 s
```

Primetimo da u ovom primeru, rekurzivna funckija ima dva parametra. Međutim, pri rekurzivnim pozivima, samo jedan od ta dva parametra se menja dok je drugi konstantan. U nekim drugim rekuzivnim funkcijama, pri rekurzivnom pozivu menja se više parametra (videti zadatak sa Akermanovom funkcijom).

Kao i prethodno opisana funkcija `fib`, funkcija `x` "boluje" od suvišnih izračunavanja. U ovom slučaju se pri računanju vrednosti `x n s` dva puta računa *ista* vrednost `x (n-1) s`. Zbog toga, možemo iskoristi `where` sitaksu da bi smo ukloni jedno suvišno izračunavanje. Uverite se da je naredna funkcija značajno brža od prethodno definisane:

```haskell
x n s
 | n <= 0 = s / 2
 | otherwise = (x' + s / x')
 where x' = x (n - 1) s
```

### Hanojska kula

### Particije 

## Zadaci

1. Napisati funkciju koja određuje `n`-ti stepen broja.

2. Napisati funkciju koja određuje zbir neparnih cifara prirodnog broja.

3. Napisati funkciju koja određuje količnik dva prirodna broja na `k` decimala.

4. Napisati funkciju koja određuje binomni koeficijent *`n` bira `k`* (`n` nad `k`). 

5. Napisati funkciju koja oređuje najveći zajednički delilac dva prirodna broja (koristiti [Euklidov algoritam](https://en.wikipedia.org/wiki/Euclidean_algorithm)).

6. Spratovi jedne zgrade se kreče u zeleno, plavo ili crveno. Svaki sprat se kreči u jednu od te tri boje. Na koliko načina je moguće okrečiti zgradu, ako važi pravilo da se dva susedna sprata ne smeju okrečiti istom bojom.

7. Za proizvoljan prirodan broj `n` definišemo njegov Kolacov niz na sledeći način: `x₀ = n`, `xₙ₊₁ = xₙ / 2` ako je `xₙ` parno, odnosno `xₙ₊₁ = 3 * xₙ + 1` ako je `xₙ` neparno. Pritom ako je `xₙ₊₁ = 1` niz se prekida. Na primer Kolacov niz za `n = 12` je `12`, `6`, `3`, `10`, `5`, `16`, `8`, `4`, `2`, `1`. Pretopstavlja se da će se Kolacov niz svakog prirodnog broja evetualno prekinuti, tj. da će se pojaviti `1` u njemu. Naći prirodan broj manji od 10000 koji ima najduži Kolacov niz.

8. U Srbiji se koriste kovane novčanice od `1`, `2`, `5`, `10` i `20` dinara. Na koliko različitih načina je moguće formirati `40` dinara koristeći kovanice (na primer, jedan način je `10 * 1 + 2 * 5 + 1 * 20`)?

9. *Metoda polovjenja intervala* je numerička metoda određivanja korena neprekidne funkcija tipa `ℝ → ℝ`. Posmatrajmo interval `[a, b]`. Ako za funkciju `f` važi da je `f(a) < 0` i `f(b) > 0` (ili da je `f(a) > 0` i `f(b) < 0`) za neke brojeve `a < b`, tada zbog neprekidnosti znamo da postoji `x`, `a < x < b`, takvo da je `f(x) = 0`. Uzmimo `c = (a + b) / 2`. Ako je `f(c) /= 0` postupak možemo da ponovimo za jedan od intervala `[a , c]` ili `[c, b]` (naravno, ako je `f(c) = 0`, postupak prekidamo). Na ovaj način dobijamo niz intervala čija dužina se prepolovljava, i za koje znamo da sadrže barem jedno rešenje jednačine `f(x) = 0`. Stoga, u `n` koraka možemo odrediti koren jednačine sa greškom manjom od `(b-a)/2ⁿ`. Koristeći ovaj metod, naći koren polinoma `p(x) = 2x³-4x²-6x+2` na intervalu `[1, 4]` sa greškom ne većom od `0.001`.

10. [Akermanova funkcija](https://en.wikipedia.org/wiki/Ackermann_function) funkcija koja zavisi od dva prirodna broja (`m` i `n`). Ova funkcija poseduje mnoga zanimljiva svojstva, a jedno je to da izuzetno brzo raste (u odnosu na argumente). Na primer `A(4, 2)` je broj sa više od 19 hiljada decimala. Pročitati Vikipedija članak o Akermanovoj funkciji i implementirati je u Haskelu. Proveriti vrednosti `A(m, n)`, za `m ∈ {0, 1, 2, 3}` i `n ∈ {0, 1, 2, 3, 4}`. 
