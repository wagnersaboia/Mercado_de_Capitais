2# Lista1 - Mercado_de_Capitais
# 245 retornos diarios entre 05/09/2016 e 01/09/2017 das acoes ABEV3, EMBR3, GOLL4, PETR4 e VALE5.

using HypothesisTests

Retornos = readdlm("C:/Users/wagne/AppData/Local/JuliaPro-0.6.0.1/Mercado_de_Capitais/Retornos_e_CDI.csv",';',Float64)
Retornos = Retornos[:,2:end]

Rf = Retornos[:,end]

# Estes pesos são calculados com base no valor de mercado das empresas na data 8 de Setembro de 2017
w = [0.443561213661192
     0.274423889726137
     0.255663125423664
     0.019045872730312
     0.007305898458695]

Rm = Retornos[:,1:(end-1)]*w

Test_Results = Vector(5)
for i in 1:5
  x = Rm - Rf
  y = Retornos[:,i] - Rf
  (alpha,beta) = linreg(vec(x),vec(y))
  Test_Results[i] = OneSampleTTest(vec(y),beta.*vec(x))
end

Test_Results
