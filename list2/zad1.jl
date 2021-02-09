# Author: Paweł Data

using Printf

function calcSumFront(array1, array2, type)
	sum = zero(type)
	for i = 1:5
		sum += type(type(array1[i]) * type(array2[i]))
	end
	return sum
end

function calcSumBack(array1, array2, type)
	sum = zero(type)
	for i = 5:-1:1
		sum += type(type(array1[i]) * type(array2[i]))
	end
	return sum
end

function calcSumBigToSmall(array1, array2, type)
	posSum = zero(type)
	negSum = zero(type)
	array = sort([ type(type(array1[i]) * type(array2[i])) for i = 1:5])
	for n in reverse(array)
		if n > 0
			posSum += n
		end
	end
	for n in array
		if n < 0
			negSum += n
		end
	end
	return posSum + negSum
end

function calcSumSmallToBig(array1, array2, type)
	posSum = zero(type)
	negSum = zero(type)
	array = sort([ type(type(array1[i]) * type(array2[i])) for i = 1:5])
	for n in array
		if n > 0
			posSum += n
		end
	end
	for n in reverse(array)
		if n < 0
			negSum += n
		end
	end
	return posSum + negSum
end

array1 = [2.718281828, -3.141592654, 1.414213562, 0.577215664, 0.301029995]
array2 = [1486.2497, 878366.9879, -22.37492, 4773714.647, 0.000185049]

@printf("Type\tfloat32\t\tfloat64\n")

@printf("1\t%.10f\t%.10e\n",
	calcSumFront(array1, array2, Float32),
	calcSumFront(array1, array2, Float64))
@printf("2\t%.10f\t%.10e\n",
	calcSumBack(array1, array2, Float32),
	calcSumBack(array1, array2, Float64))
@printf("3\t%.10f\t%.10e\n",
	calcSumBigToSmall(array1, array2, Float32),
	calcSumBigToSmall(array1, array2, Float64))
@printf("4\t%.10f\t%.10e\n",
	calcSumSmallToBig(array1, array2, Float32),
	calcSumSmallToBig(array1, array2, Float64))
