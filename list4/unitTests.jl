# Author: Paweł Data

include("interpolation.jl")

using .interpolation
using Test

delta = (10)^(-3)

@testset "ilorazRoznicowy" begin
    @testset "simple example" begin
        x = [3.0, 1.0, 5.0, 6.0]
        f = [1.0, -3.0, 2.0, 4.0]
        result = [1.0, 2.0, -3.0/8.0, 7.0/40.0]

        differenceQuotient = ilorazyRoznicowe(x, f)

        @test differenceQuotient ≈ result atol = delta
    end
end

@testset "warNewton" begin
    @testset "f(x) = x^2" begin
        f(x) = x^2
        x = [Float64(i) for i = -2:2]
        f = [f(i) for i in x]
        fx = ilorazyRoznicowe(x, f)

        value = warNewton(x, fx, 0.5)
        @test value ≈ 0.25 atol = delta

        value = warNewton(x, fx, 2.5)
        @test value ≈ 6.25 atol = delta 
    end

    @testset "f(x) = x + pi" begin
        f(x) = x + pi
        x = [Float64(i) for i = -2:2]
        f = [f(i) for i in x]
        fx = ilorazyRoznicowe(x, f)

        value = warNewton(x, fx, 10.0)
        @test value ≈ 10.0 + pi atol = delta

        value = warNewton(x, fx, -15.0)
        @test value ≈ -15.0 + pi atol = delta 
    end
end

@testset "naturalna" begin
    @testset "f(x) = 10 + 3x + 7x^2 - 5x^3" begin
        f(x) = 10 + 3x + 7x^2 - 5x^3
        x = [Float64(i) for i = -2:2]
        f = [f(i) for i in x]
        fx = ilorazyRoznicowe(x, f)

        result = naturalna(x, fx)
        @test result ≈ [10.0, 3.0, 7.0, -5.0, 0.0] atol = delta
    end

    @testset "f(x) = 24 - 15.7x + 0.456x^2 - 13.67x^3 + 1.5x^4" begin
        f(x) = 24 - 15.7x + 0.456x^2 - 13.67x^3 + 1.5x^4
        x = [Float64(i) for i = -2:2]
        f = [f(i) for i in x]
        fx = ilorazyRoznicowe(x, f)

        result = naturalna(x, fx)
        @test result ≈ [24.0, -15.7, 0.456, -13.67, 1.5] atol = delta
    end
end
