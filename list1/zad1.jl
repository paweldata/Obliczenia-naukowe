# Author: Paweł Data

function getMacheps(type)
	n = one(type)
	nPrev = n
	while 1 + n > 1
		nPrev = n
		n /= 2
	end
	return nPrev
end

function getEta(type)
	n = one(type)
	nPrev = n
	while n > 0
		nPrev = n
		n /= 2
	end
	return nPrev
end

function getMax(type)
	n = prevfloat(one(type))
	nPrev = n
	while !isinf(n)
		nPrev = n
		n *= 2
	end
	return nPrev
end

types = [Float16, Float32, Float64]

for T in types
	println(T, ", Calculate macheps : ", getMacheps(T), ", original : ", eps(T))
end

for T in types
	println(T, ", Calculate eta : ", getEta(T), ", original : ", nextfloat(T(0)))
end

for T in types
	println(T, ", Calculate max : ", getMax(T), ", original : ", floatmax(T))
end

