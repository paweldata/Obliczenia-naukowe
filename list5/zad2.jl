# Author: Paweł Data
include("blocksys.jl")

using .blocksys

matrix, matrixSize, matrixElemSize  = readMartix("Dane16_1_1/A.txt")
matrixLU = calculateLU(matrix, matrixSize, matrixElemSize)

matrix, matrixSize, matrixElemSize  = readMartix("Dane16_1_1/A.txt")
matrixLUWithChoose, perm = calculateLUWithChoose(matrix, matrixSize, matrixElemSize)

println(matrixLU)
println(matrixLUWithChoose)
