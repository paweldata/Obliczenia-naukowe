# Author: Paweł Data

module ZerosFunctions

export mbisekcji, mstycznych, msiecznych


"""
Funkcja liczy pierwiastek funkcji uzywajac metody bisekcji
Dane:
f – funkcja f(x) zadana jako anonimowa funkcja,
a, b – konce przedziału poczatkowego
delta, epsilon – dokladnosci obliczen,
Wyniki:
(r, v, it, err) – czworka, gdzie
r – przyblizenie pierwiastka rownania f(x) = 0,
v – wartosc f(r)
it – liczba wykonanych iteracji,
err – sygnalizacja bledu
    0 - metoda zbiezna
    1 - funkcja nie zmienia znaku w przedziale [a,b]
"""
function mbisekcji(f, a::Float64, b::Float64, delta::Float64, epsilon::Float64)
    iteration = 1
    left = min(a, b)
    right = max(a, b)
    mid = left + (right - left) / 2
    leftValue = f(a)
    rightValue = f(b)
    midValue = f(mid)

    if sign(leftValue) == sign(rightValue)
        return (0, 0, 0, 1);
    end

    while abs(left - right) >= delta && abs(midValue) >= epsilon
        if sign(leftValue) == sign(midValue)
            left = mid
            leftValue = midValue
        else
            right = mid
            rightValue = midValue
        end

        mid = left + (right - left) / 2
        midValue = f(mid)
        iteration += 1
    end

    return (mid, midValue, iteration, 0)
end

"""
Funkcja oblicza pierwiastek funkcji uzywajac metody stycznych
Dane:
f – funkcja f(x) zadana jako anonimowa funkcja,
x0, x1 – przyblizenia poczatkowe,
delta, epsilon – dokladnosci obliczen,
maxit – maksymalna dopuszczalna liczba iteracji,
Wyniki:
(r, v, it, err) – czworka, gdzie
r – przyblizenie pierwiastka rownania f(x) = 0,
v – wartosc f(r)
it – liczba wykonanych iteracji,
err – sygnalizacja bledu
    0 - metoda zbiezna
    1 - nie osiągnieto wymaganej dokladnosci w maxit iteracji
    2 - pochodna bliska zeru
"""
function mstycznych(
    f,
    pf,
    x0::Float64,
    delta::Float64,
    epsilon::Float64,
    maxit::Int
    )
    value = f(x0)
    x1 = x0

    if abs(value) < epsilon
        return (x0, value, 0, 0)
    end

    for it = 1:maxit
        pfValue = pf(x0)

        if abs(pfValue) < epsilon
            return (0, 0, it, 2)
        end

        x1 = x0 - value / pfValue
        value = f(x1)

        if abs(x0 - x1) < delta || abs(value) < epsilon
            return (x1, value, it, 0)
        end

        x0 = x1
    end

    return (0, 0, maxit, 1)
end

"""
Funkcja oblicza pierwiastek funkcji uzywajac metody siecznych
Dane:
f – funkcja f(x) zadana jako anonimowa funkcja,
x0, x1 – przyblizenia poczatkowe,
delta, epsilon – dokladnosci obliczen,
maxit – maksymalna dopuszczalna liczba iteracji,
Wyniki:
(r, v, it, err) – czworka, gdzie
r – przyblizenie pierwiastka rownania f(x) = 0,
v – wartosc f(r)
it – liczba wykonanych iteracji,
err – sygnalizacja bledu
    0 - metoda zbiezna
    1 - nie osiagnieto wymaganej dokladnosci w maxit iteracji
"""
function msiecznych(
    f,
    x0::Float64,
    x1::Float64,
    delta::Float64,
    epsilon::Float64,
    maxit::Int
    )
    x0Value = f(x0)
    x1Value = f(x1)

    for it = 1:maxit
        if abs(x0Value) > abs(x1Value)
            tmp = x0
            x0 = x1
            x1 = tmp
            tmp = x0Value
            x0Value = x1Value
            x1Value = tmp
        end

        new = (x1 - x0) / (x1Value - x0Value)
        x1 = x0
        x1Value = x0Value
        x0 = x0 - x0Value * new
        x0Value = f(x0)

        if abs(x1 - x0) < delta || abs(x0Value) < epsilon
            return (x0, x0Value, it, 0)
        end
    end

    return (0, 0, maxit, 1)
end

end
