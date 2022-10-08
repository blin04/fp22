# Skupovi i funkcije

Svakom programeru je jasna povezanost matematike i programiranja. U funkcionalnom ta veza je mnogo dublja nego što je to slučaj kod imperativne ili objektno orijentisane paradigme. Zbog toga, pre nego što započnemo sa funkcionalnim programiranjem, moramo se podsetiti nekih matematičkih osnova.

## Skupovi


Za naše potrebe, dovoljno je poznavanje teorije skupova na nivou *naivne* teorije skupova.Za nas *skup* predstavlja nekakvu kolekciju elemenata. Činjenicu da element `x` pripada skupu `S` obeležavamo sa `x ∈ S`.

U matematici, često se sreću sledeći skupovi: skup prirodnih brojeva `ℕ`, skup celih brojeva `ℤ`, skup racionalnih brojeva `ℚ`, skup realnih brojeva `ℝ`, skup kompleksnih brojeva `ℂ`, itd...

Između dva skupa mogu se uspostaviti nekakve relacije. Ako su su svi elementi skupa `A` ujedno i elementi skupa `B`, tada kažemo da je skup `A` *podskup* skupa `B`, i to označavamo sa `A ⊆ B`. Ako istovremeno važi da je `A ⊆ B` i `B ⊆ A` tada za skupove `A` i `B` kažemo da su *jednaki* i to označavamo sa `A = B`. Dakle, skupovi su jednaki ako i samo ako imaju iste elemente. Ako skupovi `A` i `B` nemaju nijedan zajednički element, tada za te skupove kažemo da su *disjunktni*.

**Primer** Važi `ℕ ⊆ ℤ`, `ℤ ⊆ ℚ`, `ℚ ⊆ ℝ`, `ℝ ⊆ ℂ`.

Kao što nad brojevima možemo vršiti aritmetičke operacije, nad logičkim vrednostima logičke operacije itd, tako i nad skupovima možemo vršiti neke operacije:

+ *Unija* skupova `A` i `B`, u oznaci `A ∪ B`, je skup koji sadrži sve elemente skupa `A` i sve elemente skupa `B` i drugih elemenata nema.
+ *Presek* skupova `A` i `B`, u oznaci `A ∩ B`, je skup koji sadrži samo elemente koji pripadaju i skupu `A` i skupu `B`.
+ *Razlika* skupova `A` i `B`, u oznaci `A \ B`, je skup koji sadrži samo elemente skupa `A` koji ne pripadaju skupu `B`.
+ *Dekartov proizvod* skupova `A` i `B`, u oznaci `A ⨯ B`,  je skup svih uređenih parova, čija prva koordinata pripada skupu `A` a druga koordinata pripada skupu `B`.

Ako je skup `X` ima konačno mnogo elemenata, tada sa `|X|` označavamo broj elemenata skupa `X`.

## Funkcije

Funkcija je jedan od najosnovnijih pojmova matematike, a kao što ćemo i videti, i funkcionalnog programiranja.

Formalno, pojam funkcije u matematici se definiše preko pojma relacije, koji se definiše preko pojma Dekartovog proizvoda skupova. Ovakav pristup preko teorije skupova za nas nije od velike važnosti, te ćemo dati naivnu ali pragmatičnu definiciju: *Funkcija je pravilo po kom se svakom elementu jednog skupa (kog nazivamo domen funkcije), pridružuje jedinstven element drugog skupa (kog nazivamo kodomen funkcije)*.

Dakle, funkcija je zapravo pridruživanje elemenata domena elementima kodomena. Činjenicu da neka funkcija `f` ima domen `X` i kodomen `Y` zapisujemo kao `f: X → Y` i za samu funkciju `f` kažemo da je *`f` funkcija iz `X` u `Y`*. Izraz  `X → Y` nazivamo *tip* funkcije. Činjenicu da funkcija `f` pridržužuje element `y` elementu `x` zapsiujemo kao `f(x) = y`.

**Primeri**:

+ funkcija `f: ℝ → ℝ` definisana sa `f(x) = 2*x` pridružuje svakom realnom broju njegovu dvostruku vrednost.
+ na svakom skupu `X` moguće je definisati *identičku funkciju* `idX: X → X` za koju važi `idX(x) = x`.
+ ako je `X` proizvoljan skup, `Y` neprazan skup, i `c` proizvoljan element skupa `Y`, tada možemo definisati *konstantnu funkciju* `f(x) = c`. Ova funkcija svim elementima skupa `X` pridružuje element `c`.
+ ako je `X` prazan skup tada postoji jedinstvena funkcija iz `X` u proizvoljan skup `Y`. Ovu funkciju nazivamo *prazna funkcija*. Ona ne uzima argumente, niti daje vrednosti.
+ ako `X` nije prazan skup, a `Y` jeste prazan skup, tada ne postoji funkcija tipa `X → Y`. Jer u suprotnom, nekom elementu `x` iz `X` bi mora biti pridružen element `y` iz `Y` što je nemoguće.

Funkcije između skupova brojeva najčešće zadajemo analitičkim izrazima. Ponekad funkciju i zadajemo razdvajanjem na slučajeve u zavisnosti od argumenta. Na primer, funkcija `abs: ℝ → ℝ` može se definisati:

```plaintext
        ⎧  x, ako je x ≥ 0 
abs x = ⎨
        ⎩ -x, ako je x < 0
```

Kad god imamo funkcije `f: X → Y` i `g: Y → Z`, tada možemo konstruisati novu funkciju `h: X → Z` *kompozicijom* funkcija `f` i `g` sledećim izrazom `h(x) = g(f(x))`. Činjenicu da je `h` kompozicija funkcija `f` i `g` označavamo sa `h = g ∘ f`.


```plaintext
┌─────┐  f   ┌─────┐  g   ┌─────┐
│  X  ├──────►  Y  ├──────►  Z  │
└──┬──┘      └─────┘      └──▲──┘
   │                         │
   └─────────────────────────┘
             g ∘ f
```


Kompozicija `g ∘ f` ima smisla samo ako je kodomen funkcije `f` jednak domenu funkcije `g`. Ali čak i kada `g ∘ f` ima smisla ne mora važiti `g ∘ f = f ∘ g`. Ipak, za identičku funkciju `id` važi `id ∘ f = f = f ∘ id`.

Kompozicija funkcija je asocijativna operacija, odnosno važi `(h ∘ g) ∘ f = h ∘ (g ∘ f)` kad god navedene kompozicije imaju smisla.


## Funkcije u matematici i u programiranju

U mnogim programskim jezicima susrećemo se s pojmom funkcije. Iako su te funkcije bliske "matematičkom" pojmu funkcije, ipak postoje neke suptilne razlike.

### Hardverska ograničenja

Na primer, pandan "matematičkoj" funkciji sabiraranja `+: ℤ × ℤ → ℤ` u imperativnom programiranju bi bila funkcija poput sledeće

```C
int sum (int a, int b) {
    return a + b;
}
```

Iako na prvi pogled jednake, funkcija napisana u `C` jeziku neće vratiti uvek sumu svojih argumenata. Njena preciznost je ograničena dužinom procesorske reči računara na kom se izvršava, i za dovoljno velike vrednosti argumenta, može doći do ograničenja. Slično navedenom hardverskom ograničenju, neke funkcije su ograničene nedostatkom radne memorije. Naravno, kada govorimo o matematičoj definiciji funkcija, ovakva ograničenja nas mnogo ne interesuju.

Međutim, moderni računari su izuzetno moćni, pa često u praksi možemo zanemariti hardverska ograničenja.

### Matematičke funkcije su totalne

Za razliku od "matematičkih" funkcija, koje su definisane na svakom elementu domena, funkcije u računarstvu to ne moraju biti. Na primer, posmatrajući samo potpis naredne C funkcije, mogli bismo da zaključimo da je ona tipa `ℤ → ℤ`.

```C
int f (int a) {
    int j = 0;
    for (int i = 100; i > 1; i = i / a) {
        j++
    }
    return j;
}
```

Ipak, navedena funkcija nije definisana za `a = 1`, jer će u tom slučaju program ući u beskonačnu petlju.

U računarstvu, funkcije koje su definisane za svaki argument domena, nazivamo *totalnim*. Nažalost, u opštem slučaju je nemoguće reći da li je neka funkcija totalna. Ovo ograničenje leži u samim osnovama teorijskog računarstva i ne možemo mnogo učiniti za njegovo rešavanje.

### Matematičke funkcije su čiste

Postoji još jedna aspekt po kom se matematički i programerski pojam funkcije razlikuju. Za razliku od "matematičkih" funkcija koje za isti argument uvek daju istu vrednost, mnoge funkcije u programiranju nemaju ovu osobinu. Na primer, C funkcija `scanf` (ili `gets`, `getline`, itd...) koja učitava nisku iz korisničkog intervala će uvek vratiti neku novu vrednost. Isto važi i za `random` funkciju koja vraća nasumičnu vrednost.

Takođe, matematičke funkcije nemaju *propratne efekte* (eng. *side efects*), odnosno ne menjaju kontekst koji ih okružuje. Sa druge strane, funkcije u programskim jezicima imaju neke propratne efekte: menjaju vrednost globalne promenljive ili sadržaj datoteke u memoriji, ispisuju karaktere na ekran ili reprodukuju zvuk, pokreću robote ili lansiraju rakete...

U računarstvu za funkciju kažemo da je *čista* (eng. *pure*) ako zavisi samo od ulaznih argumenata i nema bočnih efekata. Pojam čistih funkcija je bitan, jer za takve funkcije možemo garantovati da uvek vraćaju ispravne vrednosti, a često ih možemo i značajno optimizovati (prilikom kompajliranja).

## Zadaci

1. Neka su `X` i `Y` konačni skupovi, i neka važi `|X|=n` i `|Y|=m`. Koliko je `|X ⊔ Y|`, a koliko `|X × Y|`?
2. Neka su dati skupovi `A = {1}` i `B = {{1}, {{1}}}`. Odrediti `A ∩ B` i `A × B`. Da li važi `A ∈ B`? Da li važi `A ⊆ B`?
3. Ako je `X = {1, 2, 3, 4, 5, 6, 7, 8}` a `Y = {a, b, c, d, e, f}`, naći `(X × Y) ∩ (Y × X)`.
4. Neka su dati skupovi `A = {1, 2, 3}`, `B = {a, b}` i `C = {△, □}`. Naći skup `(A × B) × C`. Da li postoji skup `X` takav da je `A × X = {(1, 1), (1, b), (2, 1), (2, b), (3, 1), (3, b)}`?
5. Naći sve skupove `A` takve da važi `A ∩ ℕ = ∅` i `A ∪ ℕ = ℕ`
6. Naći primer funkcija `f` i `g` takvih da je `f ∘ g = g ∘ f`.
7. Naći primer funkcije `f` takve da je `f = f ∘ f = f ∘ f ∘ f = ...`.
8. Naći primer funkcije takve da je `f ≠ f ∘ f` i `f = f ∘ f ∘ f`
9. Naći sve funkcije iz skupa `X = {1, 2, 3}` u `Y = {a, b, c}`.
10. Naći sve konstantne funkcije iz `ℕ` u `{a, b, c}`.
11. Da li u programskim jezicima koje poznajete možete isprogramirati funkciju koja vraća kompoziciju dve proizvoljne funkcije odgovarajućih tipova?


## Dodatni resursi

1. [Barber & Russell Paradoxes - Computerphile](https://www.youtube.com/watch?v=FK3kifY-geM)