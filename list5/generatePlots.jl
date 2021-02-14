# Author: Paweł Data
include("blocksys.jl")
include("matrixgen.jl")

using .blocksys
using .matrixgen
using SparseArrays
using PyPlot
using Printf

REPS = 10
MAXSIZE = 15000
MINSIZE = 1000
JUMPSIZE = 1000
MATRIXELEMSIZE = 4
FILENAME = "text.txt"

function solveGauss(
    matrix::SparseMatrixCSC{Float64, Int64},
    vector::Vector{Float64},
    matrixSize::Int64,
    matrixElemSize::Int64
    )
    matrixLU = calculateLU(matrix, matrixSize, matrixElemSize)
    gaussWithLU(matrixLU, vector, matrixSize, matrixElemSize)
end

function solveGaussWithChoose(
    matrix::SparseMatrixCSC{Float64, Int64},
    vector::Vector{Float64},
    matrixSize::Int64,
    matrixElemSize::Int64
    )
    matrixLUWithChoose, perm = calculateLUWithChoose(matrix, matrixSize, matrixElemSize)
    gaussWithLUWithChoose(matrixLUWithChoose, perm, vector, matrixSize, matrixElemSize)
end

function solveGaussMoreTimes(
    matrix::SparseMatrixCSC{Float64, Int64},
    vector::Vector{Float64},
    matrixSize::Int64,
    matrixElemSize::Int64,
    times::Int64
    )
    for i = 1:times
        gauss(matrix, vector, matrixSize, matrixElemSize)
    end
end

function solveGaussWithLUMoreTimes(
    matrix::SparseMatrixCSC{Float64, Int64},
    vector::Vector{Float64},
    matrixSize::Int64,
    matrixElemSize::Int64,
    times::Int64
    )
    matrixLUWithChoose, perm = calculateLU(matrix, matrixSize, matrixElemSize)
    for i = 1:times
        gaussWithLU(matrix, vector, matrixSize, matrixElemSize)
    end
end

function test(functionForTest)
    for matrixSize in MINSIZE:JUMPSIZE:MAXSIZE
        totalTime = 0
        totalMemory = 0

        for i in 1:REPS
            blockmat(matrixSize, MATRIXELEMSIZE, 1.0, FILENAME)
            (matrix, _) = readMartix(FILENAME)
            vector = calculateRightSideVector(matrix, matrixSize, MATRIXELEMSIZE)

            (_, time, memory) = @timed functionForTest(matrix, vector, matrixSize, MATRIXELEMSIZE)
            totalTime += time
            totalMemory += memory
        end

        @printf("%d\t%.10f\t%d\n", matrixSize, totalTime / REPS, totalMemory / REPS)
    end
end

function testMoreTimesForOneMatrix(functionForTest, times::Int64)
    for matrixSize in MINSIZE:JUMPSIZE:MAXSIZE
        totalTime = 0
        totalMemory = 0

        for i in 1:REPS
            blockmat(matrixSize, MATRIXELEMSIZE, 1.0, FILENAME)
            (matrix, _) = readMartix(FILENAME)
            vector = calculateRightSideVector(matrix, matrixSize, MATRIXELEMSIZE)

            (_, time, memory) = @timed functionForTest(matrix, vector, matrixSize, MATRIXELEMSIZE, times)
            totalTime += time
            totalMemory += memory
        end

        @printf("%d\t%.10f\t%d\n", matrixSize, totalTime / REPS, totalMemory / REPS)
    end
end

function readDataFromFile(filepath::String)
    size = []
    time = []
    memory = []

    open(filepath) do file
        for line in eachline(file)
            data = split(line)
            push!(size, parse(Int64, data[1]))
            push!(time, parse(Float64, data[2]))
            push!(memory, parse(Float64, data[3]))
        end
    end

    return size, time, memory
end

function genPlot(
    filepath1::String,
    filepath2::String,
    filename::String
    )
    size, time, memory = readDataFromFile(filepath1)
    sizeWC, timeWC, memoryWC = readDataFromFile(filepath2)

    clf()
    plot(size, time, label = "gauss", linewidth = 2)
    plot(size, timeWC, label = "LU", linewidth = 2)
    grid(true)
    legend(loc = 2, borderaxespad = 0)
    title("Time")
    savefig(string(filename, "Time.png"))

    clf()
    plot(size, memory, label = "gauss", linewidth = 2)
    plot(size, memoryWC, label = "LU", linewidth = 2)
    grid(true)
    legend(loc = 2, borderaxespad = 0)
    title("Memory")
    savefig(string(filename, "Memory.png"))
end

# test(solveGaussWithChoose)
# testMoreTimesForOneMatrix(solveGaussMoreTimes, 10)

# genPlot("wynikiGauss.txt", "wynikiGaussWithChoose.txt", "wykres")
# genPlot("wynikiGauss10Times.txt", "wynikiGaussLU10Times.txt", "wykresTimes")
