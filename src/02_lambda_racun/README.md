# Lambda račun

## Istorija

Početkom XX veka matematičari su pokušali da formalno definišu pojam izračunljivosti. Tokom  tridesetih godina prošlog veka pojavilo se nekoliko različitih formalizama:

+ Kurt Gedel je zasnovao pojam izračunljivosti na osnovu *μ rekurzivnih funkcija*.
+ Alan Tjuring je pojam izračunljivost definisao pomoću pojma tzv. *Tjuringove mašine*.
+ Alonco Čerč je definisao λ račun za potrebe istraživanja matematičke logike, da bi ubrzo uvideo da se λ račun takođe može iskoristiti za definiciju izračunljivosti.

Ubrzo nakon publikovanja ovih formalizama, ispostavilo se da su formalizmi isti! Tačnije, za funkciju `f: ℕ → ℕ` sledeća tvrđenja su ekvivalentna:

+ `f` pripada klasi *μ rekurzivnih funkcija*.
+ `f` se može izračunati Tjuringovom mašinom.
+ `f` je λ izračunljiva.

Činjenica da su tri nezavisno definisana formalizma međusobno ekvivalentna, ide u prilog *Čerč-Tjuringovoj* tezi koja tvrdi da *svaka intuitivno izračunljiva funkcija je Tjuring izračunljiva*.

Osim što daju odgovor na pitanje izračunljivosti funkcija, navedeni formalizmi imaju dublji smisao.

Gedelova teorija rekurzivnih funkcija je dala odgovore na mnoga duboka pitanja matematičke logike i teorijskog računarstva. Slično je i sa Tjuringovim formalizmom, koji je osim toga dao i model modernog računara.

Čerčov λ račun je najjednostavniji ali i najapstraktniji od sva tri navedena formalizma. Lambda račun je povezan s ostalim matematičkim teorijama (teorija dokaza i teorija kategorija), i predstavlja teorijsku osnovu svih funkcionalnih programskih jezika.

## Račun

Lambda račun je sistem koji opisuje osnovne načine kombinacija funkcija i primena tih funkcija na vrednosti. U osnovi lambda računa su lambda izrazi koji odgovaraju definicijama funkcija.

Definicija funkcija

```
Klasičan oblik   f(x) = x² + 2
Lambda račun     f = λx.x² +2
```

Primena funkcije na argument

```
Klasičan oblik  f (2)
Lambda račun    f 2
```

Kao što se u aritmetici pojam *račun* odnosi na pojednostavljenje aritmetičkih izraza uz pomoć aritmetičkih pravila, tako je λ račun u suštini proces pojednostavljenja λ izraza pomoću određenih pravila.

Skup lambda izraza `Λ` je najmanji skup za koji važi:

+ Promenljive `x`, `y`, `z`... pripadaju skupu `Λ`.
+ Ako je `x` promenljiva i `M` pripada `Λ`, tada i `(λx.M)` pripada skupu `Λ`.
+ Ako `M` i `N` pripadaju skupu `Λ`, tada `(M N)` pripada skupu `Λ`.

Izraz `(λx. M)` nazivamo *apstrakcijom* izraza `M`, a izraz `(M N)` nazivamo *aplikacijom* (ili *primenom*) izraza `M` na izraz `N`.

### Interpretacija lambda izraza

Lambda izrazi se mogu shvatiti kao uopštenja definicija i primene funkcija:

+ Aplikacija `M N` se može intrpretirati kao primena "funkcije" `M` na vrednost `N`, tj. `M(N)`.
+ Apstrakcija `λx.M` se može interpretirati kao definicija "funkcije" čija vrednost za argument `N` se dobija zamenom svih pojavljanja pomenljive `x` u `M` sa `N`.

Na primer, lambda izraz `λx.x` se može shvatiti kao identička funkcija `f(x) = x`, dok se lambda izraz `λx.y` može shvatiti kao konstantna "funkcija" `f(x) = y`.

### Zagrade u lambda izrazima

Kao što pri radu sa aritmetičkim izrazima možemo izostaviti neke zagrade, tako i u lambda računu postoje pravila koja pojednostavljuju zapis lambda izraza:

1. **Spoljne zagrade ne zapisujemo**: umesto `(M)` pišemo `M`.
2. **Aplikacija lambda izraza je levo-asocijativna**: umesto `((M N) P)` pišemo `(M N P)`
3. **Apstrakcija je desno asocijativna**: umesto `λx.(λy.M)` pišemo `λx.λy.M`
4. **Aplikacija ima veći prioritet u odnosu na apstrakciju**: umesto `λx.(M N)` pišemo `λx.M N`.

Osim navedenih pravila sa zagradama, postoji još jedno pravilo koje skraćuje zapis:

5. **Višestruke apstrakcije možemo spojiti pod jednu lambdu**: umesto `λx.λy.M` pišemo `λxy.M`, umesto `λx.λy.λz.M` pišemo `λxyz.M` i sl.

### Sintaksna jednakost lambda izraza

Kada su dva lambda izraza, `M` i `N`, jednaka kao dva niza simbola, tada za njih kažemo da su sintaksno jednaki i pišemo `M ≡ N`. Pri ovom poređenju ignorišemo razlike u zagradama koje se uspostavljaju opisanom konvencijom o pisanju zagrada.

Na primer `λx.(x  y) ≡ λx.x  y /≡ λz.z  y.`

### Vezane i slobodne promenljive

Za razumevanje pojmova koji slede, potrebno je razumeti koncept *slobodne promenljive*.

Skup svih slobodnih promenljivih `FV(M)` lambda izraza `M` definišemo na sledeći način:

+ `FV(M) = {x}` ako je `M ≡ x`.
+ `FV(M N) = FV(M) ∪ FV(N)`.
+ `FV(λx.M) = FV(M) \ {x}`.

Za promenljivu `x` koja se nalazi u izrazu `M` a ne pripada `FV(M)` kažemo da je *vezana*. Po trećoj tački gornje definicje, takva promenljiva mora biti *vezana* barem jednom *lambdom*.

### Zamena promenljiva

Lambda izrazi `λx.x` i `λy.y` *nisu* sintaksno jednaki. Ipak, interpretirani kao funkcije, ovi izrazi predstavljaju istu funkciju, odnosno *identičku* funkciju `f(a) = a`.

U matematici je jasno da zamena imena promenljive (uz određenu opreznost) suštinski ne menja funkciju (npr. `f(x)=sin(x)` i `g(z)=sin(z)` su iste realne funkcije). Stoga je korisno, zapravo neophodno, uvesti sličnu vrstu ekvivalencije u lambda račun.

Neka su `x`, `y` i `z` različite promenljive. Zamenu izraza `N` u slobodna ponavljanja promenljive `x` u izrazu `M` označavamo sa `M [N/x]`. Preciznije:

+ `x [N/x] ≡ N`.
+ `y [N/x] ≡ y` za svako `y ≠ x`.
+ `(P  Q) [N/x] ≡(P [N/x]) (Q [N/x])`.
+ `(λx.P) [N/x] ≡ λx.P`.
+ `(λy.P) [N/x] ≡ λx.(P [N/x])` ako `y ∉ FV(N)`.
+ `(λy.P) [N/x] ≡ λz.(P [z/y][N/x])` ako `y ∈ FV(N)`.

### Alfa konverzija

Neka je lambda izraz `M` sadrži izraz oblika `λx.P` pri čemu `y ∉ FV(P)`. *Alfa konverzijom* nazivamo postupak zamene izraza `λx.P` u `λy.(P [y/x])`.

Ako se izraz `P` može transformisati u izraz `Q` konačnom primenom alfa konverzija, tada kažemo da su `P` i `Q` *alfa ekvivalentni* i pišemo `P = Q`.

Relacija `=` jeste relacije ekvivlencije, odnosno važi:

+ `M = M` (refleksivnost)
+ Ako `M = N` tada i `N = M` (simetričnost)
+ Ako `M = M` i `N = P` tada i `M = P` (tranzitivnost)

### Beta redukcija

Svaki izraz oblika `(λx.M) N` nazivamo *redeks*. Proces zamene redeksa `(λx.M) N` s izrazom `M [N/x]` nazivamo *kontrakcija*.

Ako izraz `P` sadrži redeks `(λx.M) N`, tada kontrakcijom redeksa `(λx.M) N` dobijamo novi lambda izraz `P'`. Ovaj postupak nazivamo *beta redukcija*.

Beta redukciju izraza možemo da vršimo dokle god imamo redeks u izrazu. Ako se od `P` u konačno mnogo redukcija može dobiti `P'` tada pišemo `P → P'`.

Lambda izraz koji ne sadrži redeks ne možemo da dalje da redukujemo i za taj izraz kažemo da je u *normalnoj formi*. Ako se lambda izraz `M` može svesti u normalnu formu u konačno mnogo redukcija, tada za `M` kažemo da poseduje normalnu formu.

Na primer, izraz `(λx.(λy.x y)) u v` nije u normalnoj formi, ali poseduje normalnu formu jer se u dve beta redukcije svodi na `u v`:


```
(λx.(λy.x y)) u v → (λy.u y) v → u v
```

Ipak, nema svaki lambda izraz normalnu formu:

```
(λx.x x) (λx.x x) → (λx.x x) (λx.x x) → (λx.x x) (λx.x x) → ...
```

Kao što vidimo, postupak beta redukcije izraza `(λx.x x) (λx.x x)` se nikad ne završava. Štaviše, naredni primer pokazuje da proces beta redukcije može neograničeno uvećavati složenost izraza:

```
(λx.x x y) (λx.x x y) → (λx.x x y) (λx.x x y) y → (λx.x x y) (λx.x x y) y y → ...
```

Naredno pitanje koje možemo postaviti o beta redukciji tiče se poretka redukovanja redeksa u izrazima: da li će nas svaki redosled redukcija dovesti do istog rešenja?

**Prva Čerč-Roserova teorema** Ako `M → N₁` i `M → N₂` tada postoji lambda izraz `T` takav da `N₁ → T` i `N₂ → T`

### Funkcije više promenljiva

Funkcije više promenljiva su izuzetno važne i za matematiku i za programiranje. Međutim, `λ` račun dozvoljava definisanje samo funkcija jedne promenljive (pravilom apstrakcije), što na prvi pogled deluje kao ograničenje.

Pre nego što pokažemo da je lamda račun dovoljno ekspresivan da opiše funkcije više promenljiva  pogledajmo jedan primer.  

Operacija sabiranja brojeva (npr. celih), nije ništa drugo nego funkcija dve promenljive:

```
S(m,n) = m + n.
```

Osim funkcije `S`, možemo posmatrati i funkcije `Sₘ` definisane sa:

```
Sₘ(n)= m + n.
```

Definišimo funkciju `Σ` koja celom broju `m` dodeljuje *funkciju* `Sₘ`:

```
Σ(m) = Sₘ.
```

Sada sabiranje brojeva, funkciju od dva argumenta, možemo predstaviti uz pomoć dve funkcije jedne promenljive:

```
m + n = Sₘ(n) = (Σ(m))(n)
```

Dakle, da bismo sabrali brojeve `m` i `n`, prvo smo funkciju `Σ` primenili na broj `m`, a zatim smo rezultat te primene primenili na broj `n`.

Opisana tehnika predstavljanja funkcija više promenljiva pomoću funkcija jedne promenljive naziva se *karijevanje* (eng. currying, po logičaru Haskell Curry-ju).

Tehnika karijevanja nam daje interpretaciju višestruke apstrakcije. Od sada, lambda izraz oblika `λx₁.λx₂...λxₙ.N` možemo shvatiti kao funkciju `n` promenljiva.

## Zadaci

Svesti naredne izraze na normalnu formu:

+ `(λx.x y) (λu.v u u)`
+ `λxy.y x u v`
+ `(λx.x (x (y z) x)) (λu.(u v))`
+ `(λx.x x y) (λy.y z)`
+ `(λxy.x y y) (λu.u y x)`
+ `(λxyz.x z (y z)) ((λxy.y x) u) ((λxy.y x) v) w`

Navesti jedan lambda izraz `M` koji nema normalnu formu. Da li izraz `(λx.c) M` ima normalnu formu?
