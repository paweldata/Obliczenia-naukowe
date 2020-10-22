# Author: Paweł Data

function f(x)
	return sin(x) + cos(3*x)
end

function derivativeF(x)
	return cos(x) - 3*sin(3*x)
end

function derivativeFAprox(f, x, h)
	return (f(x + h) - f(x)) / h
end

println("f'(1) = ", derivativeF(1))

for i = 0:54
	println(i, ", ", abs(derivativeF(1) - derivativeFAprox(f, 1, Float64(2)^(-i))))
end

