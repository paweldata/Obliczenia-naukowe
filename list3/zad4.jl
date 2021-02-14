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

f(x) = sin(x) -  (x / 2)^2
pf(x) = cos(x) - x / 2

delta = (10)^(-5) / 2
epsilon = (10)^(-5) / 2

println("Mbijekcji")
showResult(mbisekcji(f, 1.5, 2.0, delta, epsilon))
println("Mstycznych")
showResult(mstycznych(f, pf, 1.5, delta, epsilon, 100))
println("Msiecznych")
showResult(msiecznych(f, 1.0, 2.0, delta, epsilon, 100))
