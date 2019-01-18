function binprod_nlp3(;solver=nothing)

	m = Model(solver=solver)

	@variable(m, x[1:8])
	@variable(m, y[1:5], Bin)

	setlowerbound(x[1], 100)
	setlowerbound(x[2], 1000)
	setlowerbound(x[3], 1000)
	setlowerbound(x[4], 10)
	setlowerbound(x[5], 10)
	setlowerbound(x[6], 10)
	setlowerbound(x[7], 10)
	setlowerbound(x[8], 10)

	setupperbound(x[1], 10000)
	setupperbound(x[2], 10000)
	setupperbound(x[3], 10000)
	setupperbound(x[4], 1000)
	setupperbound(x[5], 1000)
	setupperbound(x[6], 1000)
	setupperbound(x[7], 1000)
	setupperbound(x[8], 1000)

	@constraint(m, 0.0025*(x[4]*y[1] + x[6]*y[2]) <= 1)
	@constraint(m, 0.0025*(x[5] - x[4]*y[1] + x[7]) <= 1)
	@constraint(m, 0.01(x[8]-x[5]*y[3]) <= 1)
	@NLconstraint(m, 100*x[1] - x[1]*x[6]*y[1] + 833.33252*x[4]*y[1] <= 83333.333)
	@NLconstraint(m, x[2]*x[4]*y[4] - x[2]*x[7] - 1250*x[4] + 1250*x[5] <= 0)
	@NLconstraint(m, x[3]*x[5]*y[2]*y[5] - x[3]*x[8]*y[5] - 2500*x[5]*y[1]*y[4] + 1250000 <= 0)

	@NLconstraint(m, y[1]*y[2]*y[3] <= 0)
	@NLconstraint(m, y[2]*y[3] >= y[4]*y[5])
	@NLconstraint(m, y[1]*y[5] <= y[2]*y[4])

	@objective(m, Min, x[1]+x[2]+x[3])

	return m
end

function circlebin(;verbose=false, solver=nothing)

	m = Model(solver=solver)

    @variable(m, x[1:5], Bin)
    @NLconstraint(m, x[1]^2 + x[2]^2 >= 2)
    @objective(m, Min, x[1]+x[2])

	return m
end

function bpml(;verbose=false, solver=nothing)

	m = Model(solver=solver)

	@variable(m, x[1:5], Bin)
	@variable(m, y[1:5]>=0)

	@NLconstraint(m, x[1]*y[1] >= 10)
	@NLconstraint(m, x[1]*x[2]*y[1] >= 10)
	@NLconstraint(m, x[1]*x[2]*x[3]*y[1] >= 10)
	@NLconstraint(m, x[1]*y[1]*y[2] >= 10)
	@NLconstraint(m, x[1]*y[1]*y[2]*y[3] >= 10)
	@NLconstraint(m, x[1]*x[2]*x[3]*y[1]*y[2]*y[3] >= 10)
	@NLconstraint(m, x[1]*x[2]*x[3]*x[4]*x[5] >= 1)
	@NLconstraint(m, y[1]*y[2]*y[4]*y[5]*y[1] >= 99)

	@objective(m, Min, x[1]+x[2]+x[3])

	return m
end

function bmpl_linearlifting(;solver=nothing)

	m = Model(solver=solver)

	@variable(m, x[1:5], Bin)
	@variable(m, y[1:5]>=0)

	@NLconstraint(m, 15*x[1]*(2*y[1]+y[2]) >= 10)
	@NLconstraint(m, 15*(x[1]+x[2]*y[1])*(y[1]+y[2]*x[1]*x[2]) + 10 >= 10)
	@NLconstraint(m, 15*x[2]*(y[1]+y[2]*x[3]*y[5]*x[4]) + 50 >= 10)

	@NLobjective(m, Min, x[1] * (y[1]*y[2]*y[3] + x[2]*x[3]))

	return m
end

function bpml_lnl(solver=nothing)

	m = Model(solver=solver)

	VERSION > v"0.7.0-" ? Random.seed!(10) : srand(10) 
	@variable(m, X[1:5], Bin)
	@variable(m, 0.1<=Y[1:5]<=0.1+10*rand())
	@constraint(m,  sum(X) >= 3)
	@NLobjective(m, Min, sum(X[i]*Y[i] for i in 1:5))

	return m
end

function bpml_binl(solver=nothing)

	m = Model(solver=solver)

	VERSION > v"0.7.0-" ? Random.seed!(10) : srand(10)
	@variable(m, X[1:5], Bin)
	@variable(m, 50<=Y[1:5]<=50+100*rand()*rand())
	@constraint(m, sum(X) >= 3)
	@NLobjective(m, Max, sum(X[i]*Y[i]*Y[i+1] for i in 1:4) - X[5]*Y[5]*Y[1])

	return m
end

function bpml_monl(solver=nothing)

	m = Model(solver=solver)

	VERSION > v"0.7.0-" ? Random.seed!(10) : srand(10)
	@variable(m, X[1:5], Bin)
	@variable(m, 50<=Y[1:5]<=50+100*rand()*rand())
	@constraint(m, sum(X) >= 3)
	@NLobjective(m, Max, sum(X[i]*Y[i]*Y[i] for i in 1:5))

	return m
end

function bpml_negative(solver=nothing)

	m = Model(solver=solver)

	VERSION > v"0.7.0-" ? Random.seed!(10) : srand(10)
	@variable(m, X[1:5], Bin)
	@variable(m, 50<=Y[1:5]<=50+100*rand()*rand())
	setlowerbound(Y[1], -10)
	setupperbound(Y[1], -1)
	setlowerbound(Y[2], -40)
	setlowerbound(Y[3], -30)
	setlowerbound(Y[4], -50)
	@constraint(m, sum(X) >= 3)
	@NLobjective(m, Max, sum(X[i]*Y[i]*Y[i+1] for i in 1:4) - X[5]*Y[5]*Y[1])

	return m
end

function intprod_basic(;solver=nothing)
	m = Model(solver=solver)

	@variable(m, 1 <= Z[1:10] <= 10, Int)
	@NLconstraint(m, (Z[1]+Z[2])*(Z[3]+Z[4]) >= 25)
	@NLconstraint(m, Z[1]*(Z[2]+Z[3])*Z[4] >= 25)
	@NLconstraint(m, Z[1]-Z[2]*Z[3]*Z[4]+15 >= 25)
	@NLconstraint(m, Z[5]*(Z[2]-Z[3])*Z[5]^2 >= 40)
	@NLobjective(m, Min, sum(Z[i] for i in 1:5)*Z[2])

	return m
end

function discretemulti_basic(;solver=nothing)

	m = Model(solver=solver)

	VERSION > v"0.7.0-" ? Random.seed!(10) : srand(10)
	@variable(m, X[1:5], Bin)
	@variable(m, 0.1<=Y[1:5]<=0.1+10*rand())
	@variable(m, 1<=Z[1:5]<=10, Int)
	@constraint(m,  sum(X) >= 3)
	@constraint(m,  sum(Z) >= 10)
	@NLobjective(m, Min, sum(X[i]*Y[i] for i in 1:5))
	@NLconstraint(m, sum(X[i]*Z[i] for i in 1:5) >= 8)
	@NLconstraint(m, [i in 1:5], Y[i]*Z[i] >= 17.1)
	@NLconstraint(m, [i in 1:4], Y[i]*Z[i]*Z[i+1] >= 18.6)
	@NLconstraint(m, [i in 1:5], X[i]*Y[i]*Z[i] <= 28.1)
	@NLconstraint(m, [i in 1:4], X[i]*X[i+1]*Y[i]*Y[i+1]*Z[i]*Z[i+1] <= 33.2)

	return m
end