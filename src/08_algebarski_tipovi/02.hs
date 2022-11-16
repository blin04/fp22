-- zadaci radjeni na casu 16.11.22

--prvi
data Valuta = EUR | RSD | USD 
        deriving(Show)
--drugi
data Svota = Svota Float Valuta
        deriving(Show)

--treci
data Banka = Intesa | Unicredit | Procredit
        deriving(Show)

--cetvrti
data Racun = Racun Int Banka
        deriving(Show)

--peti
uEvre::Svota -> Svota
uEvre (Svota x RSD) =  Svota (x/117) EUR
uEvre (Svota x USD) =  Svota (x * 0.96) EUR
uEvre (Svota x EUR) =  Svota x EUR

--sesti
Transakcija::Svota->Svota->Racun
