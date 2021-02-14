# Author: Paweł Data

include("functions.jl")

using .ZerosFunctions: msiecznych

f(x) = x^2 - 2
x0 = 2.0
x1 = 3.0
delta = 10^(-5)
epsilon = 10^(-5)
it = 100

println(msiecznych(f, x0, x1, delta, epsilon, it))