cifra::Int->Int
cifra x = if mod x 2 == 1 then x else 0

iteriraj::Int->Int
iteriraj 0 = 0
iteriraj n = (cifra (mod n 10)) + (iteriraj (div n 10)) 
