# Author: Paweł Data

include("functions.jl")

using .ZerosFunctions: mbisekcji, mstycznych, msiecznych
using Printf

function showResult((x, value, it, err))
    if err == 0
        @printf("x = %.15f\t value = %.15f\t iteration = %.0f\n", x, value, it)
    else
        println("Error : ", err)
    end
end

f1(x) = exp(1-x) - 1
pf1(x) = -exp(1-x)
f2(x) = x * exp(-x)
pf2(x) = -exp(-x) * (x-1)

delta = (10)^(-5)
epsilon = (10)^(-5)

println("exp(1-x) - 1")
println("Mbijekcji")
showResult(mbisekcji(f1, -1.0, 1.0, delta, epsilon))
println("Mstycznych")
showResult(mstycznych(f1, pf1, 0.0, delta, epsilon, 100))
println("Msiecznych")
showResult(msiecznych(f1, 0.0, 0.5, delta, epsilon, 100))

println("x * exp(-x)")
println("Mbijekcji")
showResult(mbisekcji(f2, -1.0, 1.0, delta, epsilon))
println("Mstycznych")
showResult(mstycznych(f2, pf2, -1.0, delta, epsilon, 100))
println("Msiecznych")
showResult(msiecznych(f2, -1.0, -0.5, delta, epsilon, 100))

println("Newton's method test")
showResult(mstycznych(f1, pf1, 5.0, delta, epsilon, 100))
showResult(mstycznych(f2, pf2, 10.0, delta, epsilon, 100))
