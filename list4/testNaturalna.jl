# Author: Paweł Data

include("interpolation.jl")

using .interpolation

f(x) = 10 + 3x + 7x^2 - 5x^3
x = [Float64(i) for i = -2:2]
values = [f(i) for i in x]
fx = ilorazyRoznicowe(x, values)

println(naturalna(x, fx))
