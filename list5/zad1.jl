# Author: Paweł Data
include("blocksys.jl")

using .blocksys

matrix, matrixSize, matrixElemSize  = readMartix("Dane16_1_1/A.txt")
vector = readVector("Dane16_1_1/b.txt")
gaussResult = gauss(matrix, vector, matrixSize, matrixElemSize)

matrix, matrixSize, matrixElemSize  = readMartix("Dane16_1_1/A.txt")
vector = readVector("Dane16_1_1/b.txt")
gaussWithEchooseResult = gaussWithChoose(matrix, vector, matrixSize, matrixElemSize)

println(gaussResult)
println(gaussWithEchooseResult)
