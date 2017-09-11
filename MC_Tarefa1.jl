# Lista1 - Mercado_de_Capitais - Wagner Saboia de Abreu 1713877
# 245 retornos diarios entre 05/09/2016 e 01/09/2017 das acoes ABEV3, EMBR3, GOLL4, PETR4 e VALE5.

using JuMP
using Gurobi
using Gadfly

Retornos = readdlm("C:/Users/wagne/AppData/Local/JuliaPro-0.6.0.1/Mercado_de_Capitais/Retornos.txt",Float64)
μ = mean(Retornos,1)
Σ = cov(Retornos)
n = size(Retornos)[2]

# Questao 2
function Markowitz1(n,Σ,μ,R)
  m = Model(solver=GurobiSolver(Presolve=0))
  @variable(m,x[1:n])
  @objective(m, Min, x'*Σ*x)
  @constraint(m, x'*ones(n) == 1)
  @constraint(m, μ*x .== R)
  solve(m)
  return(getobjectivevalue(m))
end

Rets1 = linspace(-.001,.002,1000+1)
sigmas1 = [Markowitz1(n,Σ,μ,Rets1[i]) for i=1:length(Rets1)]
plot(x = sigmas1,y = Rets1)

# Questao 3
function Markowitz2(n,Σ,μ,R)
  m = Model(solver=GurobiSolver(Presolve=0))
  @variable(m,x[1:n])
  @objective(m, Min, x'*Σ*x)
  @constraint(m, x'*ones(n) == 1)
  @constraint(m, μ*x .>= R)
  solve(m)
  return(getobjectivevalue(m))
end

Rets2 = linspace(-.001,.002,1000+1)
sigmas2 = [Markowitz2(n,Σ,μ,Rets2[i]) for i=1:length(Rets2)]
plot(x = sigmas2,y = Rets2)

# Questao 4
# Insira o valor de Rf em % a.a.
Rf = 0.07
Rf = (1+Rf)^(1/252)-1
Rets3 = linspace(-.001,.002,1000+1)
sigmas3 = [Markowitz2(n,Σ,μ,Rets3[i]) for i=1:length(Rets2)]
function MaxSharpeRatio(n,Σ,μ,Rf)
  i = 1
  while ((Rets3[i+1]-Rf)/sigmas3[i+1]<(Rets3[i]-Rf)/sigmas3[i])
    i = i + 1
  end
  m = Model(solver=GurobiSolver(Presolve=0))
  @variable(m,x[1:n])
  @objective(m, Min, x'*Σ*x)
  @constraint(m, x'*ones(n) == 1)
  @constraint(m, μ*x .== Rets3[i])
  solve(m)
  return getvalue(x)
end

X = MaxSharpeRatio(n,Σ,μ,Rf)
plot(x = linspace(1,5,5), y = X)
