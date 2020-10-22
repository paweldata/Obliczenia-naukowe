# Author: Paweł Data

for T in (Float16, Float32, Float64)
	myEps = abs(T(3) * (T(4) / T(3) - T(1)) - T(1))
	println(T, ", Calculate macheps : ", myEps, ", original : ", eps(T))
end

