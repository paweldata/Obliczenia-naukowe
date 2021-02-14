# Author: Paweł Data

include("functions.jl")

using .ZerosFunctions: mbisekcji

f(x) = x^2 - 2
left = 0.0
right = 2.0
delta = 10^(-5)
epsilon = 10^(-5)

println(mbisekcji(f, left, right, delta, epsilon))
