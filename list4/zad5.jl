# Author: Paweł Data

include("interpolation.jl")

using .interpolation

f1(x) = exp(x)
f2(x) = x^2 * sin(x)

degrees = [5, 10, 15]

for degree in degrees
    rysujNnfx(f1, 0.0, 1.0, degree, string("zad5a_", degree))
    rysujNnfx(f2, -1.0, 1.0, degree, string("zad5b_", degree))
end
