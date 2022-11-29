deljiv::Int->Int
deljiv x = if ((mod x 5 == 0) || (mod x 3 == 0)) then x else 0

zbir::[Int]->Int
zbir [] = 0
zbir (x:xs) = x + (zbir xs) 
