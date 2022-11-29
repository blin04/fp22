myLast::[a]->a
myLast [a] = a
myLast (x:xs) = myLast xs 

secondToLast::[a]->a
secondToLast [a] = a
secondToLast [a, b] = a
secondToLast (x:xs) = secondToLast xs

myReverse::[a]->[a]
myReverse [] = []
myReverse (x:xs) = (myReverse xs) ++ [x]

