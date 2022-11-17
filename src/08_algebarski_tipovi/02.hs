data Valuta = EUR | RSD | USD 
        deriving(Show, Eq)

data Svota = Svota Float Valuta
        deriving(Show, Eq)

data Banka = Intesa | Unicredit | Procredit
        deriving(Show, Eq)

data Racun = Racun Int Banka
        deriving(Show, Eq)

data Transakcija = Transakcija Svota Racun Racun
        deriving(Show)

uEvre :: Svota -> Svota
uEvre (Svota x RSD) = Svota (x/117) EUR
uEvre (Svota x USD) = Svota (x * 0.96) EUR
uEvre (Svota x EUR) = Svota x EUR

saberiSvote :: Svota->Svota->Svota
saberiSvote x y = Svota (a + b) EUR
        where (Svota a _) = uEvre x
              (Svota b _) = uEvre y

oduzmiSvote::Svota->Svota->Svota
oduzmiSvote x y = Svota (a - b) EUR
        where (Svota a _) = uEvre x
              (Svota b _) = uEvre y

rac1, rac2, rac3 :: Racun
rac1 = Racun 5311 Intesa
rac2 = Racun 2398 Unicredit
rac3 = Racun 3735 Procredit

transakcije :: [Transakcija]
transakcije = [  
   Transakcija (Svota 100 EUR) rac1 rac2,
   Transakcija (Svota 10 EUR) rac2 rac3,
   Transakcija (Svota 200 EUR) rac1 rac3,
   Transakcija (Svota 300 EUR) rac2 rac1,
   Transakcija (Svota 150 EUR) rac3 rac1,
   Transakcija (Svota 17 EUR) rac3 rac2,
   Transakcija (Svota 1 EUR) rac1 rac2,
   Transakcija (Svota 210 EUR) rac1 rac3,
   Transakcija (Svota 320 EUR) rac2 rac3,
   Transakcija (Svota 25 EUR) rac3 rac1,
   Transakcija (Svota 90 EUR) rac2 rac1 ]


promenaNaRacunu :: Racun -> Transakcija -> Svota
promenaNaRacunu r (Transakcija sv r1 r2) = oduzmiSvote dobitak gubitak 
       where dobitak = if r == r2 then sv else (Svota 0 EUR)
             gubitak = if r == r1 then sv else (Svota 0 EUR)


-- promenu na racunu `rac` mozemo da izracunamo tako sto
-- za svaku transkaciciju izracunamo koliku promenu je izvrsila na `rac`
-- a zatim saberemo sve te promene koristeci fold1 i `saberiSvote`

promena :: [Transakcija] -> Racun -> Svota
promena niz rac = foldl1 saberiSvote (map (promenaNaRacunu rac) niz)

-- malo elegantnija implementacija
-- prethodna implementacija je imala oblik `f(g(niz))`
-- gde je `f = foldl1 saberiSvote` i 
-- g = map (promenaNaRacunu rac)
-- Zbog toga možemo da iskoristimo operator kompozije `.`
-- i predstavimo `promena' rac` kao kompoziciju funkcija `f` i `g`
-- Obratite paznju da je redosled argumenata zamenjen
promena' :: Racun -> [Transakcija] -> Svota
promena' rac = (foldl1 saberiSvote) . map (promenaNaRacunu rac)

-- jos elegantnije
-- aplikacija argumenta ima najveci prioritet,
-- te je moguce izostaviti prve zagrade
promena'' :: Racun -> [Transakcija] -> Svota
promena'' rac =  foldl1 saberiSvote . map (promenaNaRacunu rac)
