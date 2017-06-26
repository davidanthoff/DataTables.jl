module TestConversions
    using Base.Test
    using DataTables
    using DataStructures: OrderedDict, SortedDict

    dt = DataTable()
    dt[:A] = 1:5
    dt[:B] = [:A, :B, :C, :D, :E]
    @test isa(convert(Array, dt), Matrix{Any})
    @test convert(Array, dt) == convert(Array, convert(DataValueArray, dt))
    @test isa(convert(Array{Any}, dt), Matrix{Any})

    dt = DataTable()
    dt[:A] = 1:5
    dt[:B] = 1.0:5.0
    # Fails on Julia 0.4 since promote_type(DataValue{Int}, DataValue{Float64}) gives DataValue{T}
    if VERSION >= v"0.5.0-dev"
        @test isa(convert(Array, dt), Matrix{Float64})
    end
    @test convert(Array, dt) == convert(Array, convert(DataValueArray, dt))
    @test isa(convert(Array{Any}, dt), Matrix{Any})
    @test isa(convert(Array{Float64}, dt), Matrix{Float64})

    dt = DataTable()
    dt[:A] = DataValueArray(1.0:5.0)
    dt[:B] = DataValueArray(1.0:5.0)
    a = convert(Array, dt)
    aa = convert(Array{Any}, dt)
    ai = convert(Array{Int}, dt)
    @test isa(a, Matrix{Float64})
    @test a == convert(Array, convert(DataValueArray, dt))
    @test a == convert(Matrix, dt)
    @test isa(aa, Matrix{Any})
    @test aa == convert(Matrix{Any}, dt)
    @test isa(ai, Matrix{Int})
    @test ai == convert(Matrix{Int}, dt)

    dt[1,1] = NA
    @test_throws ErrorException convert(Array, dt)
    na = convert(DataValueArray, dt)
    naa = convert(DataValueArray{Any}, dt)
    nai = convert(DataValueArray{Int}, dt)
    @test isa(na, DataValueMatrix{Float64})
    @test isequal(na, convert(DataValueMatrix, dt))
    @test isa(naa, DataValueMatrix{Any})
    @test isequal(naa, convert(DataValueMatrix{Any}, dt))
    @test isa(nai, DataValueMatrix{Int})
    @test isequal(nai, convert(DataValueMatrix{Int}, dt))

    a = DataValueArray([1.0,2.0])
    b = DataValueArray([-0.1,3])
    c = DataValueArray([-3.1,7])
    di = Dict("a"=>a, "b"=>b, "c"=>c)

    dt = convert(DataTable,di)
    @test isa(dt,DataTable)
    @test names(dt) == Symbol[x for x in sort(collect(keys(di)))]
    @test isequal(dt[:a], DataValueArray(a))
    @test isequal(dt[:b], DataValueArray(b))
    @test isequal(dt[:c], DataValueArray(c))

    od = OrderedDict("c"=>c, "a"=>a, "b"=>b)
    dt = convert(DataTable,od)
    @test isa(dt, DataTable)
    @test names(dt) == Symbol[x for x in keys(od)]
    @test isequal(dt[:a], DataValueArray(a))
    @test isequal(dt[:b], DataValueArray(b))
    @test isequal(dt[:c], DataValueArray(c))

    sd = SortedDict("c"=>c, "a"=>a, "b"=>b)
    dt = convert(DataTable,sd)
    @test isa(dt, DataTable)
    @test names(dt) == Symbol[x for x in keys(sd)]
    @test isequal(dt[:a], DataValueArray(a))
    @test isequal(dt[:b], DataValueArray(b))
    @test isequal(dt[:c], DataValueArray(c))

    a = [1.0]
    di = Dict("a"=>a, "b"=>b, "c"=>c)
    @test_throws DimensionMismatch convert(DataTable,di)

end
