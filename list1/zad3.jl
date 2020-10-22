# Author: Paweł Data
# Program checks the difference between floating points numbers

x = Float64(1)
println("One  : ", bitstring(x))
x = nextfloat(x)
println("next : ", bitstring(x))
x = nextfloat(x)
println("next : ", bitstring(x))
x = nextfloat(x)
println("next : ", bitstring(x))

println()

y = Float64(2)
println("Two  : ", bitstring(y))
y = prevfloat(y)
println("prev : ", bitstring(y))

