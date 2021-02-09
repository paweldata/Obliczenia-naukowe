# Author: Paweł Data

function getSequence(startValue, constVal)
	seq = Vector{Float64}(undef, 40)
	
	seq[1] = startValue^2 + constVal

	for i in 2:40
		seq[i] = seq[i-1]^2 + constVal
	end
	
	return seq
end

startValues = [1, 2, 1.99999999999999, 1, -1, 0.75, 0.25]
constValues = [-2, -2, -2, -1, -1, -1, -1]
sequences = Vector{Vector}(undef, 7)

for i in 1:7
	sequences[i] = getSequence(startValues[i], constValues[i])
end

for i in 1:40
	print(i, " ")
	for j in 1:7
		print(sequences[j][i], " ")
	end
	println()
end

