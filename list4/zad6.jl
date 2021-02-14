# Author: Paweł Data

include("interpolation.jl")

using .interpolation

f1(x) = abs(x)
f2(x) = 1.0 / (1.0 + x^2)

degrees = [5, 10, 15]

for degree in degrees
    rysujNnfx(f1, -1.0, 1.0, degree, string("zad6a_", degree))
    rysujNnfx(f2, -5.0, 5.0, degree, string("zad6b_", degree))
end
