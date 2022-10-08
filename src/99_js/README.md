# Funkcionalno programiranje u Javaskriptu

JavaScript je programski jezik koji je nastao sredinom devedesetih godina u kompaniji *Netscape* (ista kompanija je napravila neke od prvih *web* pretraživača). Jedna od početnih ideja prilikom dizajniranja JavaScript jezika je bila da bude zasnovan na LISP funkcionalnom jeziku. Ipak ova ideja nije zaživela, i JavaScript je dizajniran po uzoru na jezike *C* i *Java*. Samim tim, na samom početku JavaScript nije bio pogodan za funkcionalno programiranje.

Tokom naredne dve decenije, JavaSkript je postao jedan on najpopularnijih programskih jezika zahvaljujući neverovatnoj ekspanziji *web*-a. Uporedno sa eksapnizjom, jezik se poboljšavao kroz različita izdanja ([ECMAScript](https://en.wikipedia.org/wiki/ECMAScript)) standarda, i danas ima značajno bolju podršku za funkcionalnu paradigmu.

U nastavku biće iznete neke karakteristike funkcionalnog JavaScript koda. Tekst podrazumeva da ste već upoznati sa osnovama JavaScript jezika.

Potrebno je ovde napomenuti da Javascript poseduje slab sistem tipova, zbog čega nećemo tipovima posvetiti pažnju kao u prethodnim sekcijama. Ovaj veliki nedostatak Javaskript jezika je razrešen u *TypeScript* jeziku koji se sve češće koristi za razvoj *web* aplikacija.  

## Konstantni izrazi

Za razliku od funkcionalnih jezika, imperativni jezici dozvoljavaju promene stanja programa (konkretno promene vrednosti promenljivih). Međutim, takve promene stanja (posebno globalnih stanja) često dovode do grešaka koje se teško pronalaze i ispravaljaju. Zbog toga je u JavaScript uvedena dekleracija konstanti:

```javascript
const PI = 3.141592;
```

Dekleracijom poput gore navedene sigurni smo da vrednost `PI` nećemo slučajno promeniti. Svaki pokušaj takve promene bi doveo do izuzetka. Odlika dobrog funkcionalnog JS koda je isključivo korišćenje `const` dekleracije umesto `let`.

Treba ipak navesti da je konstantim objektima moguće menjati vrednosti polja. Prema tome, naredni kod neće dovesti do izuzetka:

```javascript
const osoba = {ime : "Nikola", godine: 25 };
osoba.godine = 26;
console.log(osoba);
```

## Funkcije

Funkcije u JavaScriptu su objekti, što je u suprotnosti sa ostalim objektno orijentisanim jezicima koji prave jasnu razliku između objekata i metoda. Kako su funkcije u JavaScriptu objekti, to znači da je i funkcijama moguće manipulisati kao i sa ostalim objektima, te su funkcije građani prvog reda u Javaskriptu. Preciznije rečeno, funkcije se mogu dodeljivati promenljivama, prosleđivati drugim funkcijama i vraćati kao povratne vrednosti. 

Na primer, možemo napistai funkciju `pozdrav` koja na osnovu jedne niske `ime` vraća funkciju koja ispisuje ime:

```javascript
function pozdrav(ime) {
    function A() {
        console.log(ime + "kaže: Pozdrav!");
    };

    return A;
}

let pozdravPetar = pozdrav("Petar");
```

```
> pozdravPetar()
Petar kaže: Pozdrav!
```

Drugi primer je malo složeniji. Konstruisaćemo funkciju `komponuj` koja na osnovu dve prosleđene funkcije vraća njihovu kompoziciju: 

```javascript
function komponuj(g, f) {
    function h(x) {
        return g(f(x));
    };

    return h;
}

function dodaj2(x){
    return x + 2;
}

function pomnozi3(x){
    return x * 3;
}

let kompozicija = komponuj(dodaj2, pomnozi3) 
```

```
> kompozicija(5)
17
```

Iako su navedena dva trivijalna primera, funkcije višeg reda se često koriste u Javaskriptu. Na primer, kada želimo da neki HTML element reaguje na neki događaj, npr. na klik, u metodi `addEventListener` tog HTML elementa prosledićemo funkciju koja će se izvršiti prilikom klika:

```javascript
function klik() {
    console.log('Kliknut sam!');
}

element.addEventListener('click', klik)
```

*Umesto gorenavedenog koda možemo i napisati kod koji polju `onclik` dodeljuje funkciju `klik`. I u tom slučaju koristimo činjenicu da su funkcije građani prvog reda, preciznije, koristimo činjenicu da možemo poljima dodeljivati funkcije.*

## Anonimne funkcije

Javaskript dozvoljava definisanje anonimnih funkcija, odnosno funkcija koje nemaju ime. Anonimne funkcije se definišu poput "običnih" funkcije:

```javascript
function (parametar) {
    ...
} 
```

Ovako definisanu funkciju nije moguće raferencirati pa samim tim ni pozvati. Na prvi pogled, anonimne funkcije nisu mnogo korisne. Ali, anonimnu funkciju moguće proslediti ili vratiti iz funkcije.

Pogledajmo jedan od prethodnih primera da bi nam bilo jasnije:

```javascript
function komponuj(g, f) {
    function h(x) {
        return g(f(x));
    };

    return h;
}
```

U navedenom primeru funkcija `h` je definisana unutar funkcije `komponuj`, i pod tim imenom se može pozvati samo unutar funkcije `komponuj`. Međutim, funkcija `h` je odmah nakon definicije vraćena iz funkcije `komponuj`. Zbog toga, umesto da lokalno definišemo funkciju `h`, možemo jednostavno vratiti anonimnu funkciju:

```javascript
function komponuj(g, f) {
    return function (x) {
        return g(f(x));
    };
}
```

Slično vraćanju anonimnih funkcija, anonimne funkcije je pogodno prosleđivati drugim funkcijama. 

Posmatrajući drugi primer koji smo naveli, umesto definisanja funkcije `klik`, možemo funkciji `addEventListener` proslediti anonimnu funkciju:

```javascript
function klik() {
    console.log('Kliknut sam!');
}

element.addEventListener('click', klik)
```

```javascript
element.addEventListener('click', function () {
    console.log('Kliknut sam!');
})
```

Kao što vidimo, korišćenjem anonimnih funkcija skraćujemo kod, što poboljšava čitljivost.

### Karijevanje

Pošto u JS možemo dosta fleksibilno "baratati" s funkcijama, lako je moguće implementirati koncept karijevanja. Kao što smo ranije napisali, karijevnaje je proces kojim se funkcija od više argumenata transformiše u funkciju jedne promenljive.

Karijevanje smo ranije demonstrirali pomoću funkcije od dva argumenta koja sabira ta dva argumenta.

```javascript
function zbir (x, y) {
    return x + y;
}
```

Karijevana verzija prethodne funkcije bi bila 

```javascript
function zbirK (x) {
    return function (y) {
        return x + y;
    }
}
```

Funkcija `zbirK` je veoma pogodna za parcijalnu aplikaciju prvog argumenta.

```javascript
const dodaj2 = zbirK(2);
const rezultat = dodaj2(3);  //5
```

Javaskript je dovoljno ekspresivan da možemo u njemo da napišemo funkciju (višeg reda) koja od prosleđene funkcije dva argumenta konstruše njenu karijevanu verziju:

```javascript
function curry(f) {
  return function(a) {
    return function(b) {
      return f(a, b);
    };
  };
};
```

Zapravo, može se napisati analogna funkcija za funkcije sa proizvoljno mnogo argumenata.

### Strelice

Javaskript poseduje specijalnu sintaksu za definisanje anonomnih funkcija, tzv. *arrow* sintaksu. Ova sintaksa dozvoljava da anonimnu funkciju definišemo korišćenjem strelice `=>` umesto ključne reči `function`. U opštem slučaju *arrow* sintaksa izgleda ovako:

```javascript
(/*ARGUMENTI FUNKCIJE*/) => {
    /*TELO FUNKCIJE*/
}
```

Na primer, funkciju koja računa minimum dva broja, možemo ovako definisati 

```javascript
(a, b) => {
    if(a <= b) {
        return a;
    } else {
        return b;
    }
}
```

*Arrow* sintaksa dozvoljava da se vitičaste zagrade izostave, ako se telo funkcije sastoji samo od `return` naredbe. U tom slučaju nakon strelice se navodi izraz koji bi stajao nakon `return` naredbe. Na primer, umesto  

```javascript
(a, b) => {
    return a + b; 
}
```

možemo napisati samo

```javascript
(a, b) => a + b
```

U slučaju kada *arrow* funkcija poseduje samo jedan parametar, tada se mogu izostaviti zagrade oko tog parametra. Na primer, funkcija koja duplira argument, može se koncizno definisati sa `a => 2 * a`.

Funkcija koja nema parametre, počinje sa `() =>`.

Kada govorimo o *arrow* sintaksa bez tela (bez vitičastih zagrada) moramo primetiti da je gotovo ista kao sintaksa u Haskelu. Zaista, izraz `a => a + 2` razlikuje se od izraza `a -> a + 2` za samo jedan jedini karakter. 

I u Javaskriptu "strelice" možemo nadovezivati, što nam omogućuje da lako konstruišemo karijevane funkcije 

```javascript
a => b => a + b
```

Iz navedenih primera, vidimo da *arrow* sintaksa značajno skraćuje kod.

## Operacije sa listama

Neke od funkcija koje smo u Haskelu koristili pri radu sa listma, definisane su i u Javaskriptu kao metode `Array` objkekata.

### Filter

Filter je metoda koja filtrira (tj. odstranjuje) elemente niza koristeći prosleđenu fukciju za testiranje. 

```javascript
const brojevi = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
const parniBrojevi = brojevi.filer(x => x % 2 === 0);
```

Naravno, umesto *arrow* notacije moguće je koristiti klasičnu sintaksu za anonimne funkcije, ili ime neke druge funkcije.

Prosleđena funkcija, takozvana *test* funkcija, treba da prihvati jedan, dva ili tri argumenta i vrati logičku vrednost. Prvi parametar test funkcije je element za koji se odlučuje da li ostaje u nizu, drugi parametar je pozicija (indeks) tog elementa u nizu, a treći element je sam niz nad kojim se poziva `filter` metod. 

Treba napomenuti da metod `filter` ne kopira elemente originalnog niza. Niz dobijen `filter` metodom sadrži reference ka objektima koji su se nalazili unutar originalnog niza.

### Map

Metod `map` vraća *novi niz* dobijen pozivanjem prosleđene funkcije na svaki od elemenata originalnog niza.

```javascript
const brojevi = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
const duploVeciBrojevi = brojevi.map(x => 2 * x);
```

Kao i metoda `filter`, `map` može da prihvati jedan, dva ili tri argumenta. Prvi parametar test funkcije je element za koji se odlučuje da li ostaje u nizu, drugi parametar je pozicija (indeks) tog elementa u nizu, a treći element je sam niz nad kojim se poziva `filter` metod.

### Reduce

Metod `reduce` je pandan `fold` funkciji. Metod `fold` izvršava prosleđenu funkciju redom nad svakim elementom niza, prosleđujući povratnu vrednost izvršavanju nad sledećim elementom.

```javascript
const brojevi = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
const zbirBrojeva = brojevi.reduce((a, b) => a + b);
```

Metod fold može da prihvati jedal ili dva argumenata. Prvi argument je funkcija pomću koje se vrši redukcija, dok je drugi argument početna vrednost. Ako početna vrednost nije navedena, prvi element se koristi kao početna vrednost. Ako početna vrednost nije navedena, i niz je prazan, dolazi do greške.

```javascript
const brojevi = [1, 2, 3, 4];
const zbir1 = brojevi.reduce((a, b) => a + b);
// (((1 + 2) + 3) + 4)
const zbir2 = brojevi.reduce((a, b) => a + b, 0);
// ((((0 + 1) + 2) + 3) + 4)
```

## Resursi

1. [Functional Programming in JavaScript](https://www.manning.com/books/functional-programming-in-javascript)
