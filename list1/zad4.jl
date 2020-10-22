# Author: Paweł Data

function findSpecialNumber()
	x = Float64(1)
	while x < 2 && x * (1/x) == 1
		x = nextfloat(x)
	end
	return x
end

println(findSpecialNumber())

