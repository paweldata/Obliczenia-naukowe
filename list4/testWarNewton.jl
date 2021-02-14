# Author: Paweł Data

include("interpolation.jl")

using .interpolation

f(x) = x^2
x = [Float64(i) for i = -2:2]
values = [f(i) for i in x]
fx = ilorazyRoznicowe(x, values)

println(warNewton(x, fx, 0.5))