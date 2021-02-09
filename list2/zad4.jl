# Author: Paweł Data

using Polynomials
using Polynomials.PolyCompat

function calcAndPrintRoots(p)
	normalPol = Poly(p[end:-1:1])
	rootsPol = poly(1.0:20.0)
	calcRoots = roots(normalPol)
	
	for i in 1:20
		normalPolValue = abs(normalPol(calcRoots[i]))
		rootsPolValue = abs(rootsPol(calcRoots[i]))
		println(i, ", ", calcRoots[i], ", ", normalPolValue, ", ", rootsPolValue, ", ", abs(i - calcRoots[i]))
	end
end

p=[1, -210.0, 20615.0,-1256850.0,
      53327946.0,-1672280820.0, 40171771630.0, -756111184500.0,          
      11310276995381.0, -135585182899530.0,
      1307535010540395.0, -10142299865511450.0,
      63030812099294896.0, -311333643161390640.0,
      1206647803780373360.0, -3599979517947607200.0,
      8037811822645051776.0, -12870931245150988800.0,
      13803759753640704000.0, -8752948036761600000.0,
      2432902008176640000.0]

println("Normal polynomials:")
calcAndPrintRoots(p)

p[2] -= (1.0/(2.0^23))
println("Changed polynomials:")
calcAndPrintRoots(p)
