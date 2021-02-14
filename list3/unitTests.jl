# Author: Paweł Data

include("functions.jl")

using .ZerosFunctions: mbisekcji, mstycznych, msiecznych
using Test

delta = (0.1)^5
epsilon = (0.1)^5

@testset "mbijekcji" begin
    @testset "sqrt(3) test" begin
        f(x) = x^2 - 2
        left = 0.0
        right = 3.0

        x, value, iteration, err = mbisekcji(f, left, right, delta, epsilon)

        @test x ≈ sqrt(2) atol = delta
        @test err == 0
    end

    @testset "pi test" begin
        f(x) = x - pi
        left = -10.0
        right = 10.0

        x, value, iteration, err = mbisekcji(f, left, right, delta, epsilon)
        
        @test x ≈ pi atol = delta
        @test err == 0
    end

    @testset "error: no zeros test" begin
        f(x) = x
        left = 1.0
        right = 2.0

        x, value, iteration, err = mbisekcji(f, left, right, delta, epsilon)

        @test err == 1
    end
end

@testset "mstycznych" begin
    @testset "sqrt(3) test" begin
        f(x) = x^2 - 2
        pf(x) = 2x
        x0 = 5.0
        it = 100

        x, value, iteration, err = mstycznych(f, pf, x0, delta, epsilon, it)

        @test x ≈ sqrt(2) atol = delta
        @test err == 0
    end

    @testset "pi test" begin
        f(x) = x - pi
        pf(x) = 1
        x0 = 5.0
        it = 100

        x, value, iteration, err = mstycznych(f, pf, x0, delta, epsilon, it)

        @test x ≈ pi atol = delta
        @test err == 0
    end

    @testset "error: not enough iterations test" begin
        f(x) = x^2 - 2
        pf(x) = 2x
        x0 = 5.0
        it = 3

        x, value, iteration, err = mstycznych(f, pf, x0, delta, epsilon, it)
        
        @test iteration == it
        @test err == 1
    end

    @testset "error: to small derivative value test" begin
        f(x) = (0.1)^6x + 5
        pf(x) = (0.1)^6
        x0 = 1.0
        it = 100

        x, value, iteration, err = mstycznych(f, pf, x0, delta, epsilon, it)

        @test err == 2
    end
end

@testset "msiecznych" begin
    @testset "sqrt(3) test" begin
        f(x) = x^2 - 2
        x0 = 10.0
        x1 = 11.0
        it = 100

        x, value, iteration, err = msiecznych(f, x0, x1, delta, epsilon, it)

        @test x ≈ sqrt(2) atol = delta
        @test err == 0
    end

    @testset "pi test" begin
        f(x) = x - pi
        x0 = 10.0
        x1 = 11.0
        it = 100

        x, value, iteration, err = msiecznych(f, x0, x1, delta, epsilon, it)

        @test x ≈ pi atol = delta
        @test err == 0
    end

    @testset "error: too less iterations test" begin
        f(x) = x^2 - 2
        x0 = 10.0
        x1 = 11.0
        it = 3

        x, value, iteration, err = msiecznych(f, x0, x1, delta, epsilon, it)

        @test iteration == it
        @test err == 1
    end
end
