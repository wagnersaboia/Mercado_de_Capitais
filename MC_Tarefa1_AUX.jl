AMBEV = readtable("C:\\Users\\wagne\\AppData\\Local\\JuliaPro-0.6.0.1\\Mercado_de_Capitais\\ABEV3.SA.csv")
PETR = readdlm("C:\\Users\\wagne\\AppData\\Local\\JuliaPro-0.6.0.1\\Mercado_de_Capitais\\PETR4.SA.csv",';')
VALE = readcsv("C:\\Users\\wagne\\AppData\\Local\\JuliaPro-0.6.0.1\\Mercado_de_Capitais\\VALE5.SA.csv",header=true)
GOL = readtable("C:\\Users\\wagne\\AppData\\Local\\JuliaPro-0.6.0.1\\Mercado_de_Capitais\\GOLL4.SA.csv")
EMBR = readtable("C:\\Users\\wagne\\AppData\\Local\\JuliaPro-0.6.0.1\\Mercado_de_Capitais\\EMBR3.SA.csv")

PETR_df = DataFrame(Data =  PETR[2:end,1], Fechamento_ajustado  =  PETR[2:end,6] )
plot(PETR_df , x=1:249, y=Fechamento_ajustado)


using PyPlot
x = linspace(1,249,249)
y = Float32(PETR[2:end,6])
plot(x,y)

convert(Array{Float64},PETR[2:end,6] .+ 0.)

x = PETR[2:end,6]
for i=1:249
  x[i] = PETR[1][:,6][i]
end

map(x->parse(Float64,x),PETR[2:end,2:6])

Retornos = readdlm("C:\\Users\\wagne\\AppData\\Local\\JuliaPro-0.6.0.1\\Mercado_de_Capitais\\Retornos.txt",'\t')
Retornos = Retornos[:,1:6]

plot(x=Retornos[:,1],y=Retornos[:,2],Geom.line)

plot(layer(x=Retornos[:,1],y=Retornos[:,2],Geom.line),
     layer(x=Retornos[:,1],y=Retornos[:,3],Geom.line),
     layer(x=Retornos[:,1],y=Retornos[:,4],Geom.line),
     layer(x=Retornos[:,1],y=Retornos[:,5],Geom.line),
     layer(x=Retornos[:,1],y=Retornos[:,6],Geom.line))

μ = mean(Retornos[:,2:6],1)

Σ = cov(Retornos[:,2:6])
