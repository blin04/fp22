data Vektor = Vektor Float Float Float deriving (Show)

saberi::Vektor->Vektor->Vektor
saberi (Vektor x1 y1 z1) (Vektor x2 y2 z2) = Vektor (x1 + x2) (y1 + y2) (z1 + z2)

skaliraj::Vektor->Float->Vektor
skaliraj (Vektor x1 y1 z1) k = Vektor (k*x1) (k*y1) (k*z1)

skalarniProizvod::Vektor->Vektor->Float
skalarniProizvod (Vektor x1 y1 z1) (Vektor x2 y2 z2) = x1*x2 + y1*y2 + z1*z2

vektorskiProizvod::Vektor->Vektor->Vektor
vektorskiProizvod (Vektor x1 y1 z1) (Vektor x2 y2 z2) = Vektor a b c
	where a = (y1*z2 - z1*y2)
	      b = -1 * (x1*z2 - z1*x2)
	      c = (x1*y2 - x2*y1)

duzina::Vektor->Float
duzina (Vektor x y z) = sqrt(x*x + y*y + z*z)
