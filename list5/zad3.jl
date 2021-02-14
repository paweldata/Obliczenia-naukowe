# Author: Paweł Data
include("blocksys.jl")

using .blocksys

matrix, matrixSize, matrixElemSize  = readMartix("Dane16_1_1/A.txt")
matrixLU = calculateLU(matrix, matrixSize, matrixElemSize)
vector = readVector("Dane16_1_1/b.txt")
result = gaussWithLU(matrixLU, vector, matrixSize, matrixElemSize)

matrix, matrixSize, matrixElemSize  = readMartix("Dane16_1_1/A.txt")
matrixLUWithChoose, perm = calculateLUWithChoose(matrix, matrixSize, matrixElemSize)
vector = readVector("Dane16_1_1/b.txt")
resultWithChoose = gaussWithLUWithChoose(matrixLUWithChoose, perm, vector, matrixSize, matrixElemSize)

println(result)
println(resultWithChoose)
