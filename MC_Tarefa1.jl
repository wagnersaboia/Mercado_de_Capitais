using JuMP, Gurobi
using Distributions,Gadfly
using DataFrames

Retornos = readdlm("C:\\Users\\wagne\\AppData\\Local\\JuliaPro-0.6.0.1\\Mercado_de_Capitais\\Retornos.txt",'\t')
Retornos = Retornos[:,1:6]

μ = mean(Retornos[:,2:6],1)
Σ = cov(Retornos[:,2:6])

n=5

function Markowitz1(n,Σ,μ,R)
  m = Model(solver=GurobiSolver(Presolve=0))
  @variable(m,x[1:n])
  @objective(m, Min, x'*Σ*x)
  @constraint(m, x'*ones(n) == 1)
  @constraint(m, μ*x .== R)
  solve(m)
  return(getobjectivevalue(m))
end

Rets = collect(linspace(-.001,.002,1000+1))
sigmas = [Markowitz1(n,Σ,μ,Rets[i]) for i=1:length(Rets)]
plot(x = sigmas,y = Rets)


function Markowitz2(n,Σ,μ,R)
  m = Model(solver=GurobiSolver(Presolve=0))
  @variable(m,x[1:n])
  @objective(m, Min, x'*Σ*x)
  @constraint(m, x'*ones(n) == 1)
  @constraint(m, μ*x .>= R)
  solve(m)
  return(getobjectivevalue(m))
end

Rets = collect(linspace(-.001,.002,1000+1))
sigmas = [Markowitz2(n,Σ,μ,Rets[i]) for i=1:length(Rets)]
plot(x = sigmas,y = Rets)


plot(layer(x=sigmas,y = Rets .+ 0.001,Geom.point),
     layer(x=sigmas,y = Rets,Geom.point))

function MaxSharpeRatio(n,Σ,μ,Rf)
  i = 1
  while ((Rets[i+1]-Rf)/sigmas[i+1]<(Rets[i]-Rf)/sigmas[i])
    i = i + 1
  end

  m = Model(solver=GurobiSolver(Presolve=0))
  @variable(m,x[1:n])
  @objective(m, Min, x'*Σ*x)
  @constraint(m, x'*ones(n) == 1)
  @constraint(m, μ*x .== Rets[i])
  solve(m)
  return(getvalue(x))
end
MaxSharpeRatio(n,Σ,μ,Rf)
