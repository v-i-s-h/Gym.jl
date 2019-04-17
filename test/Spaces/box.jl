# Tests for Box space

@testset "Box" begin
    #=
        Tests for 1-D Box spaces
    =#
    @testset "1D Box" begin
        box1 = Box(0, 255, (1,), UInt8)
        s1 = sample(box1)
        @test length(s1) == 1           # Test whether sample is one dimensional
        @test typeof(s1) == Array{UInt8,1}      # Whether of right type
        @test all(0 .<= s1 .<= 255)      # Whether the sample is within range -- 
        @test 127 ∈ box1
        @test !(256 ∈ box1)
        # TODO: Test whether the automated dtype recognition is logical
    end

    #=
        Tests for N-D Box spaces
    =#
    @testset "N-D Box" begin
        N = rand(1:42)  # Select a random value for dimension
        box1 = Box(0, 255, (N,), UInt8)
        s1 = sample(box1)
        @test length(s1) == N
        @test typeof(s1) == Array{UInt8,1}
        @test all(0 .<= s1 .<= 255)
        r1 = rand(0:255, N) # randomly select a valid point
        @test r1 ∈ box1
        # Perturb each dimension with invalid values and check whether contains rejects
        for idx ∈ 1:N
            r2 = copy(r1)
            r2[idx] += 256
            @test !(r2 ∈ box1)
            r3 = copy(r1)
            r3[idx] -= 256
            @test !(r3 ∈ box1)
        end
    end

    #=
        Tests for N1xN2 Box
    =#
    @testset "N₁×N₂ Box" begin
        N1, N2 = rand(1:42, 2)
        box1 = Box(0, 255, (N1,N2), UInt8)
        s1 = sample(box1)
        @test size(s1) == (N1,N2)
        @test typeof(s1) == Array{UInt8,2}
        @test all(0 .<= s1 .<= 255)
        r1 = rand(0:255, N1, N2)
        @test r1 ∈ box1
        # Perturb some random entries and check contains
        for i = 1:10
            idx1 = rand(1:N1)
            idx2 = rand(1:N2)
            r2 = copy(r1)
            r2[idx1,idx2] += 256
            @test !(r2 ∈ box1)
            r3 = copy(r1)
            r3[idx1,idx2] -= 256
            @test !(r3 ∈ box1)
        end
    end

    #=
        Test Box with low-high values specified
    =#
    @testset "N-D Box values" begin
        l1 = [0, 5, 10]
        h1 = [ 10, 30, 50]
        box1 = Box(l1, h1, UInt8)
        s1 = sample(box1)
        @test size(s1) == (3,)
        @test typeof(s1) == Array{UInt8,1}
        @test all(l1 .<= s1 .<= h1)
        @test l1 ∈ box1
        @test h1 ∈ box1
        @test ceil.(0.5*(l1+h1)) ∈ box1
        @test !(l1 .- 1 ∈ box1)
        @test !(h1 .+ 1 ∈ box1)
    end
    @testset "N₁×N₂ Box Values" begin
        l1 = [ 0 5; 10 15]
        h1 = [ 10 30; 50 70]
        box1 = Box(l1, h1, UInt8)
        s1 = sample(box1)
        @test size(s1) == (2,2)
        @test typeof(s1) == Array{UInt8,2}
        @test all(l1 .<= s1 .<= h1)
        @test l1 ∈ box1
        @test h1 ∈ box1
        @test ceil.(0.5*(l1+h1)) ∈ box1
        @test !(l1 .- 1 ∈ box1)
        @test !(h1 .+ 1 ∈ box1)
    end
end