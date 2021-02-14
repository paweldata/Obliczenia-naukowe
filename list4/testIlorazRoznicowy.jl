# Author: Paweł Data

include("interpolation.jl")

using .interpolation

x = [3.0, 1.0, 5.0, 6.0]
f = [1.0, -3.0, 2.0, 4.0]

println(ilorazyRoznicowe(x, f))