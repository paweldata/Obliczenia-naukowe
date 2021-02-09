# Author: Paweł Data

@enum seqType begin
	NORMAL = 1
	TRUNCATE = 2
end

function getSequence(seqType, floatType)
	seq = Vector{floatType}(undef, 40)
	value = floatType(0.01)
	r = floatType(3.0)
	
	for i in 1:40
		value += r * value * (1 - value)
		
		if i == 10 && seqType == TRUNCATE
			value = trunc(value, digits=3)
		end
		
		seq[i] = value
	end
	
	return seq
end

normal32Seq = getSequence(NORMAL, Float32)
truncate32Seq = getSequence(TRUNCATE, Float32)
normal64Seq = getSequence(NORMAL, Float64)

for i in 1:40
	println(i, ", ", normal32Seq[i], ", ", truncate32Seq[i])
end

for i in 1:40
	println(i, ", ", normal32Seq[i], ", ", normal64Seq[i])
end
