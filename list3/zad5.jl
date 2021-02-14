# Author: Paweł Data

include("functions.jl")

using .ZerosFunctions: mbisekcji
using Printf

function showResult((x, value, it, err))
    if err == 0
        @printf("x = %.15f\t value = %.15f\t iteration = %.0f\n", x, value, it)
    else
        println("Error : ", err)
    end
end

f(x) = 3*x - exp(x)

delta = (10)^(-4)
epsilon = (10)^(-4)

showResult(mbisekcji(f, 0.0, 1.0, delta, epsilon))
showResult(mbisekcji(f, 1.0, 2.0, delta, epsilon))
