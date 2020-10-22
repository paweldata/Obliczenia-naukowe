# Author: Paweł Data

using Printf

function f(x)
	return sqrt(x^2 + 1) - 1
end

function g(x)
	return x^2 / (sqrt(x^2 + 1) + 1)
end

for i = 1:10
	x = Float64(8)^(-i)
	@printf("f : %.10e\t g : %.10e\n", f(x), g(x))
end

