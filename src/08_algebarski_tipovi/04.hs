data KompleksanBroj = Kompleksan Float Float deriving(Show)

saberi::KompleksanBroj->KompleksanBroj->KompleksanBroj
saberi (Kompleksan a b) (Kompleksan c d) = Kompleksan (a + c) (b + d)

oduzmi::KompleksanBroj->KompleksanBroj->KompleksanBroj
oduzmi (Kompleksan a b) (Kompleksan c d) = Kompleksan (a - c) (b - d)

pomnozi::KompleksanBroj->KompleksanBroj->KompleksanBroj
pomnozi (Kompleksan a b) (Kompleksan c d) = Kompleksan (a * c - b * d) (a * d + b * c)

podeli::KompleksanBroj->KompleksanBroj->KompleksanBroj
podeli (Kompleksan a b) (Kompleksan c d) = Kompleksan ((a * c + b * d) / temp) ((b * c - a * d) / temp)
        where temp = c * c + d * d

