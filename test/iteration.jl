module TestIteration
    using Base.Test, DataTables, Compat

    dv = DataValueArray(DataValue{Int}[1, 2, NA])
    dm = DataValueArray([1 2; 3 4])
    dt = DataValueArray(zeros(2, 2, 2))

    dt = DataTable(A = DataValueArray(1:2), B = DataValueArray(2:3))

    for row in eachrow(dt)
        @test isa(row, DataTableRow)
        @test isequal(row[:B]-row[:A], DataValue(1))

        # issue #683 (https://github.com/JuliaStats/DataFrames.jl/pull/683)
        @test typeof(collect(row)) == @compat Array{Tuple{Symbol, Any}, 1}
    end

    for col in eachcol(dt)
        @test isa(col, @compat Tuple{Symbol, DataValueVector})
    end

    @test isequal(map(x -> minimum(convert(Array, x)), eachrow(dt)), Any[1,2])
    @test isequal(map(minimum, eachcol(dt)), DataTable(A = DataValue{Int}[1], B = DataValue{Int}[2]))

    row = DataTableRow(dt, 1)

    row[:A] = 100
    @test isequal(dt[1, :A], DataValue(100))

    row[1] = 101
    @test isequal(dt[1, :A], DataValue(101))

    dt = DataTable(A = DataValueArray(1:4), B = DataValueArray(["M", "F", "F", "M"]))

    s1 = view(dt, 1:3)
    s1[2,:A] = 4
    @test isequal(dt[2, :A], DataValue(4))
    @test isequal(view(s1, 1:2), view(dt, 1:2))

    s2 = view(dt, 1:2:3)
    s2[2, :B] = "M"
    @test isequal(dt[3, :B], DataValue("M"))
    @test isequal(view(s2, 1:1:2), view(dt, [1,3]))

    # @test_fail for x in dt; end # Raises an error
end
