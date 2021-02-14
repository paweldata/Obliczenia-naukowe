# Author: Paweł Data

include("functions.jl")

using .ZerosFunctions: mstycznych

f(x) = x^2 - 2
pf(x) = 2x
x0 = 4.0
delta = 10^(-5)
epsilon = 10^(-5)
it = 100

println(mstycznych(f, pf, x0, delta, epsilon, it))
