# Author: Paweł Data

include("src/hilb.jl")
include("src/matcond.jl")

println("Hilb:")

for size in 1:20
	A = hilb(size)
	x = ones(Float64, size)
	b = A * x
	gaussResult = A \ b
	invResult = inv(A) * b
	gaussErr = norm(gaussResult - x) / norm(x)
	invErr = norm(invResult - x) / norm(x)
	println(size, ", ", cond(A), ", ", rank(A), ", ", gaussErr, ", ", invErr)
end

conditions = [1.0, 10.0, 10.0^3, 10.0^7, 10.0^12, 10.0^16]
sizes = [5, 10, 20]

println("Random:")

for size in sizes
	for condition in conditions
		A = matcond(size, condition)
		x = ones(Float64, size)
		b = A * x
		gaussResult = A \ b
		invResult = inv(A) * b
		gaussErr = norm(gaussResult - x) / norm(x)
		invErr = norm(invResult - x) / norm(x)
		println(size, ", ", cond(A), ", ", condition, ", ", gaussErr, ", ", invErr)
	end
end
