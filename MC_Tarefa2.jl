2# Lista1 - Mercado_de_Capitais
# 245 retornos diarios entre 05/09/2016 e 01/09/2017 das acoes ABEV3, EMBR3, GOLL4, PETR4 e VALE5.

using JuMP
using Gurobi
using Gadfly
using HypothesisTests

Retornos = readdlm("C:/Users/wagne/AppData/Local/JuliaPro-0.6.0.1/Mercado_de_Capitais/Retornos.txt",Float64)
Rf = 0.07
Rf = (1+Rf)^(1/252)-1
Rp = 0.2 .* sum(Retornos,2)

x = Rp - Rf
y = Retornos .- Rf

(alpha,beta) = linreg(vec(x),vec(y[:,1]))

test = OneSampleTTest(vec(x),beta.*vec(y[:,1]))

Test_Results = Vector(5)
for i in 1:5
  x = Rp - Rf
  y = Retornos .- Rf
  (alpha,beta) = linreg(vec(x),vec(y[:,i]))
  Test_Results[i] = OneSampleTTest(vec(x),beta.*vec(y[:,i]))
end

Test_Results
