# Author: Paweł Data

module interpolation
using PyPlot

export ilorazyRoznicowe, warNewton, naturalna, rysujNnfx


"""
funkcja oblicza ilorazy różnicowe
Dane:
x – wektor długości n+ 1 zawierający węzły x0, ..., xn,
    x[1]=x0, ..., x[n+1] = xn
f– wektor długości n+ 1 zawierający wartości interpolowanej
    funkcji w węzłach f(x0), ..., f(xn)
Wyniki:
fx– wektor długości n+ 1 zawierający obliczone ilorazy różnicowe
    fx[1] = f[x0], fx[2] = f[x0, x1], ..., 
    fx[n] = f[x0, . . . , xn−1], fx[n+1] = f[x0, . . . , xn].

"""
function ilorazyRoznicowe(x::Vector{Float64}, f::Vector{Float64})
    size = length(x)
    fx = copy(f)

    for i = 2:size
        for j = size: - 1:i
            fx[j] = (fx[j]- fx[j - 1]) / (x[j] - x[j - i + 1])
        end
    end

    return fx
end

"""
funkcja oblicza wartość wielomianu interpolacyjnego stopnia n
w postaci Newtona Nn(x) w punkcie x = t za pomocą uogólnionego 
algorytmu Hornera,
Dane:
x – wektor długości n+ 1 zawierający węzły x0, ..., xn, 
    x[1] = x0 ,..., x[n+1] = xn
fx – wektor długości n+ 1 zawierający ilorazy różnicowe 
    fx[1] = f[x0], fx[2] = f[x0, x1], ..., 
    fx[n] = f[x0, . . . , xn−1], fx[n+1] = f[x0, . . . , xn]
t – punkt, w którym należy obliczyć wartość wielomianu
Wyniki:
nt – wartość wielomianu w punkcie t.
"""
function warNewton(x::Vector{Float64}, fx::Vector{Float64}, t::Float64)
    size = length(x)
    result = fx[size]

    for i = size - 1:-1:1
        result = fx[i] + (t - x[i]) * result
    end

    return result
end

"""
funkcja oblicza współczynniki wielomanu w jego postaci naturalnej
Dane:
x – wektor długości n+ 1 zawierający węzły x0, ..., xn
    x[1] = x0, ..., x[n+1] = xn
fx – wektor długości n+ 1 zawierający ilorazy różnicowe
    fx[1] = f[x0], fx[2] = f[x0, x1], ..., 
    fx[n] = f[x0, . . . , xn−1], fx[n+1] = f[x0, . . . , xn]
Wyniki:
a – wektor długości n+ 1 zawierający obliczone współczynniki 
    postaci naturalnej a[1] = a0, a[2] = a1, ..., a[n] = an−1, a[n+1] = an.
"""
function naturalna(x::Vector{Float64}, fx::Vector{Float64})
    size = length(x)
    result = zeros(size)
    result[size] = fx[size]

    for i = size - 1:-1:1
        result[i] = fx[i] - result[i + 1] * x[i]

        for j = i + 1:size - 1
            result[j] -= result[j + 1] * x[i]
        end
    end

    return result
end

"""
funkcja interpoluje funkcję w przedziale [a, b]
oraz zapisuje wynik interpolacji do pliku
Dane:
f – funkcja f(x) zadana jako anonimowa funkcja,
a, b – przedział interpolacji
n – stopień wielomianu interpolacyjnego
Wyniki:
– funkcja rysuje wielomian interpolacyjny
    i interpolowaną funkcję w przedziale[a, b].
"""
function rysujNnfx(f,a::Float64,b::Float64,n::Int, filename="plot")
    size = n + 1
    x = zeros(size)
    defaultValues = zeros(size)
    calcValues =  zeros(size)
    arg = a
    diff = (b - a) / n

    for i in 1:size
        x[i] = arg
        defaultValues[i] = f(arg)
        arg += diff
    end

    fx = ilorazyRoznicowe(x, defaultValues)

    plotSize = size * 20
    defaultPlotValues = zeros(plotSize)
    calcPlotValues =  zeros(plotSize)
    plotX = zeros(plotSize)

    diff = (b - a) / (plotSize - 1)
    arg = a

    for i in 1:plotSize
        plotX[i] = arg
        defaultPlotValues[i] = f(arg)
        calcPlotValues[i] = warNewton(x, fx, arg)
        arg += diff
    end

    clf()
    plot(plotX, defaultPlotValues, label = "f(x)", linewidth = 3)
    plot(plotX, calcPlotValues, label = "interpolation", linewidth = 1.5)
    grid(true)
    legend(loc = 2, borderaxespad = 0)
    title(string("n = ", n))
    savefig(string(filename, ".png"))
end

end
