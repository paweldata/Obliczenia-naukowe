# Author: Paweł Data
module blocksys

using SparseArrays
using LinearAlgebra # norm()

export readMartix, readVector, gauss, gaussWithChoose,
    calculateRightSideVector, writeVector, writeVectorWithRelativeError,
    calculateLU, calculateLUWithChoose, gaussWithLU, gaussWithLUWithChoose


# funkcja czyta macierz z pliku postaci:
# n l              <= rozmiar macierzy | rozmiar podmacierzy
# i2 j2 A[i2, j2]  <= indeksy i wartosc macierzy
# i2 j2 A[i2, j2]  <= indeksy i wartosc macierzy
# ...
# Dane:
# filepath – sciezka do pliku
# Wynik:
# (matrix, size, smallerSize) – trojka, gdzie
# matrix – macierz
# size – rozmiar macierzy
# smallerSize – rozmiar podmacierzy
function readMartix(filepath::String)
    size = 0
    smallerSize = 0
    matrix = spzeros(Float64, 1, 1)

    open(filepath) do file
        data = split(readline(file))
        size = parse(Int64, data[1])
        smallerSize = parse(Int64, data[2])
        matrix = spzeros(Float64, size, size)

        for line in eachline(file)
            data = split(line)
            i = parse(Int, data[1])
            j = parse(Int, data[2])
            value = parse(Float64, data[3])

            matrix[i, j] = value
        end
    end

    return matrix, size, smallerSize
end

# funkcja czyta wektor z pliku postaci:
# n        <= rozmiar wektora
# v[1]     <= 1 wartosc wektora
# v[2]     <= 2 wartosc wektora
# ...
# Dane:
# filepath – sciezka do pliku
# Wynik:
# vector – wektor
function readVector(filepath::String) :: Vector{Float64}
    vector = []
    open(filepath) do file
        size = parse(Int64, readline(file))

        for value in eachline(file)
            push!(vector, parse(Float64, value))
        end
    end

    return vector
end

# funkcja zapisuje wektor do pliku wraz z bledem
# wzglednym z wektorem postaci (1, ..., 1)
# Dane:
# filepath – sciezka do pliku
# vector – wektor do zapisu
# size – rozmiar wektora
function writeVectorWithRelativeError(
    filepath::String,
    vector::Vector{Float64},
    size::Int64
    )
    open(filepath, "w") do file
        err = norm(ones(size) - vector) / norm(vector)
        println(file, err)

        for i = 1:size
            println(file, vector[i])
        end
    end
end

# funkcja zapisuje wektor do pliku
# Dane:
# filepath – sciezka do pliku
# vector – wektor do zapisu
# size – rozmiar wektora
function writeVector(filepath::String, vector::Vector{Float64}, size::Int64)
    open(filepath, "w") do file
        for i = 1:size
            println(file, vector[i])
        end
    end
end

# funkcja oblicza rozwiazanie rownania Ax=b eliminacja Gaussa
# Dane:
# matrix – macierz
# matrix – wektor prawych stron
# matrixSize – rozmiar macierzy
# matrixElemSize – rozmiar podmacierzy
# Wynik:
# vector – wektor 'x' z rownania Ax=b
function gauss(
    matrix::SparseMatrixCSC{Float64, Int64},
    vector::Vector{Float64},
    matrixSize::Int64,
    matrixElemSize::Int64
    )
    for j = 1:matrixSize
        for i = j + 1: getMaxBottomIndex(j, matrixElemSize, matrixSize)
            multiplier = matrix[i, j] / matrix[j, j]

            for k = j: getMaxRightIndex(j, matrixElemSize, matrixSize)
                matrix[i, k] -= multiplier * matrix[j, k]
            end

            vector[i] -= multiplier * vector[j]
        end
    end

    resultVector = zeros(matrixSize)

    for i = matrixSize: -1: 1
        sum = Float64(0)

        for j = i + 1:getMaxRightIndex(i, matrixElemSize, matrixSize)
            sum += matrix[i, j] * resultVector[j]
        end

        resultVector[i] = (vector[i] - sum) / matrix[i, i]
    end

    return resultVector
end

# funkcja oblicza rozwiazanie rownania Ax=b eliminacja Gaussa
# z czesciowym wyborem (wybor po jednym  wymiarze)
# Dane:
# matrix – macierz
# matrix – wektor prawych stron
# matrixSize – rozmiar macierzy
# matrixElemSize – rozmiar podmacierzy
# Wynik:
# vector – wektor 'x' z rownania Ax=b
function gaussWithChoose(
    matrix::SparseMatrixCSC{Float64, Int64},
    vector::Vector{Float64},
    matrixSize::Int64,
    matrixElemSize::Int64
    )
    perm = collect(1:matrixSize)

    for j = 1:matrixSize
        bestIndex = j
        bestValue = matrix[perm[j], j]

        for i = j + 1: getMaxBottomIndex(j, matrixElemSize, matrixSize)
            if abs(matrix[perm[i], j]) > abs(bestValue)
                bestValue = matrix[perm[i], j]
                bestIndex = i
            end
        end

        perm[j], perm[bestIndex] = perm[bestIndex], perm[j]

        for i = j + 1: getMaxBottomIndex(j, matrixElemSize, matrixSize)
            multiplier = matrix[perm[i], j] / matrix[perm[j], j]

            for k = j: getMaxRightIndex(j, matrixElemSize, matrixSize)
                matrix[perm[i], k] -= multiplier * matrix[perm[j], k]
            end

            vector[perm[i]] -= multiplier * vector[perm[j]]
        end
    end

    resultVector = zeros(matrixSize)

    for i = matrixSize: -1: 1
        sum = Float64(0)

        for j = i + 1:getMaxRightIndex(i, matrixElemSize, matrixSize)
            sum += matrix[perm[i], j] * resultVector[perm[j]]
        end

        resultVector[perm[i]] = (vector[perm[i]] - sum) / matrix[perm[i], i]
    end

    return resultVector
end

# funkcja generuje wektor prawych stron dla macierzy
# w taki sposob, by rozwiazanie roznania Ax=b
# byl wektor (1, ..., 1)
# Dane:
# matrix – macierz
# matrixSize – rozmiar macierzy
# matrixElemSize – rozmiar podmacierzy
# Wynik:
# vector – wektor 'b' z rownania Ax=b
function calculateRightSideVector(
    matrix::SparseMatrixCSC{Float64, Int64},
    matrixSize::Int64,
    matrixElemSize::Int64
    )
    vector = zeros(matrixSize)

    for i = 1:matrixSize
        firstIndex = getFirstLeftIndex(i, matrixElemSize)
        lastIndex = getMaxRightIndex(i, matrixElemSize, matrixSize)

        for j = firstIndex:lastIndex
            vector[i] += matrix[i, j]
        end
    end

    return vector
end

# funkcja zwraca rozklad LU dla macierzy
# Dane:
# matrix – macierz
# matrixSize – rozmiar macierzy
# matrixElemSize – rozmiar podmacierzy
# Wynik:
# matrix – rozklad LU
function calculateLU(
    matrix::SparseMatrixCSC{Float64, Int64},
    matrixSize::Int64,
    matrixElemSize::Int64
    )
    for j = 1:matrixSize
        for i = j + 1: getMaxBottomIndex(j, matrixElemSize, matrixSize)
            matrix[i, j] /= matrix[j, j]

            for k = j + 1: getMaxRightIndex(j, matrixElemSize, matrixSize)
                matrix[i, k] -= matrix[i, j] * matrix[j, k]
            end
        end
    end

    return matrix
end

# funkcja zwraca rozklad LU dla macierzy
# z czesciowym wyborem (wybor po jednym wymiarze)
# Dane:
# matrix – macierz
# matrixSize – rozmiar macierzy
# matrixElemSize – rozmiar podmacierzy
# Wynik:
# (matrix, perm) – dwojka, gdzie:
# matrix – rozklad LU
# perm – wektor permutacji rzedow w macierzy
function calculateLUWithChoose(
    matrix::SparseMatrixCSC{Float64, Int64},
    matrixSize::Int64,
    matrixElemSize::Int64
    )
    perm = collect(1:matrixSize)

    for j = 1:matrixSize
        bestIndex = j
        bestValue = matrix[j, j]
        for i = j + 1: getMaxBottomIndex(perm[j], matrixElemSize, matrixSize)
            if abs(matrix[perm[i], j]) > abs(bestValue)
                bestValue = matrix[perm[i], j]
                bestIndex = i
            end
        end

        perm[j], perm[bestIndex] = perm[bestIndex], perm[j]

        for i = j + 1: getMaxBottomIndex(j, matrixElemSize, matrixSize)
            matrix[perm[i], j] /= matrix[perm[j], j]

            for k = j + 1: getMaxRightIndex(j, matrixElemSize, matrixSize)
                matrix[perm[i], k] -= matrix[perm[i], j] * matrix[perm[j], k]
            end
        end
    end

    return matrix, perm
end

# funkcja oblicza rozwiazanie rownania Ax=b eliminacja Gaussa
# majac rozklad LU macierzy
# Dane:
# matrix – rozklad LU macierzy
# matrix – wektor prawych stron
# matrixSize – rozmiar macierzy
# matrixElemSize – rozmiar podmacierzy
# Wyniki:
# vector – wektor 'x' z rownania Ax=b
function gaussWithLU(
    matrix::SparseMatrixCSC{Float64, Int64},
    vector::Vector{Float64},
    matrixSize::Int64,
    matrixElemSize::Int64
    )
    tempVector = zeros(matrixSize)
    resultVector = zeros(matrixSize)

    for i = 1: matrixSize
        sum = Float64(0)

        for j = getFirstLeftIndex(i, matrixElemSize): i - 1
            sum += matrix[i, j] * tempVector[j]
        end

        tempVector[i] = vector[i] - sum
    end

    for i = matrixSize: -1: 1
        sum = Float64(0)

        for j = i + 1:getMaxRightIndex(i, matrixElemSize, matrixSize)
            sum += matrix[i, j] * resultVector[j]
        end

        resultVector[i] = (tempVector[i] - sum) / matrix[i, i]
    end

    return resultVector
end

# funkcja oblicza rozwiazanie rownania Ax=b eliminacja Gaussa
# z czesciowym wyborem (wybor po jednym wymiarze)
# majac rozklad LU macierzy
# Dane:
# matrix – rozklad LU macierzy
# perm – wektor permutacji rzedow w macierzy
# matrix – wektor prawych stron
# matrixSize – rozmiar macierzy
# matrixElemSize – rozmiar podmacierzy
# Wyniki:
# vector – wektor 'x' z rownania Ax=b
function gaussWithLUWithChoose(
    matrix::SparseMatrixCSC{Float64, Int64},
    perm::Vector{Int64},
    vector::Vector{Float64},
    matrixSize::Int64,
    matrixElemSize::Int64
    )
    tempVector = zeros(matrixSize)
    resultVector = zeros(matrixSize)

    for i = 1: matrixSize
        sum = Float64(0)

        for j = getFirstLeftIndex(i, matrixElemSize): i - 1
            sum += matrix[perm[i], j] * tempVector[perm[j]]
        end

        tempVector[perm[i]] = vector[perm[i]] - sum
    end

    for i = matrixSize: -1: 1
        sum = Float64(0)

        for j = i + 1:getMaxRightIndex(i, matrixElemSize, matrixSize)
            sum += matrix[perm[i], j] * resultVector[perm[j]]
        end

        resultVector[perm[i]] = (tempVector[perm[i]] - sum) / matrix[perm[i], i]
    end

    return resultVector
end

# private

function getMaxBottomIndex(j::Int64, matrixElemSize::Int64, matrixSize::Int64)
    return min(j + matrixElemSize - mod(j, matrixElemSize), matrixSize)
end

function getMaxRightIndex(i::Int64, matrixElemSize::Int64, matrixSize::Int64)
    return min(matrixSize, i + 2 * matrixElemSize)
end

function getFirstLeftIndex(i::Int64, matrixElemSize::Int64)
    return max(1, Int64(matrixElemSize * floor(Float64(i - 1) / matrixElemSize)))
end

end # blocksys
