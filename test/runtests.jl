using SeparatingHyperplanes
using Test

@testset "SeparatingHyperplanes.jl - Simple Test" begin

    # Test 1: Simple Separable Case
    P = [1.0 2.0; 2.0 3.0; 3.0 4.0]
    Q = [5.0 6.0; 6.0 7.0; 7.0 8.0]
    result = separating_hyperplane(P, Q)
    @test result.status == :Separable
    @test result.separating_distance > 0


end

@testset "SeparatingHyperplanes.jl - simple non-separable test" begin

    # Test 2: Simple Non-Separable Case
    P = [1.0 2.0; 2.0 3.0; 3.0 4.0]
    Q = [2.5 3.5; 3.5 4.5; 4.5 5.5]
    result = separating_hyperplane(P, Q)
    @test result.status == :Not_separable

end

@testset "SeparatingHyperplanes.jl - edge case (empty sets)" begin
    # Test 3: Edge Case with Empty Sets
    P = randn(0, 2)
    Q = randn(0, 5)
    @test_throws AssertionError result = separating_hyperplane(P, Q)

end

@testset "SeparatingHyperplanes.jl - edge case (single point sets)" begin
    # Test 4: Edge Case with Single Point Sets
    P = [1.0 2.0]
    Q = [3.0 4.0]
    result = separating_hyperplane(P, Q)
    @test result.status == :Separable
    @test result.separating_distance > 0

end

@testset "SeparatingHyperplanes.jl - 5D points " begin
    # Test 5: High-Dimensional Points
    P = rand(10, 5)  # 10 points in 5D
    Q = hcat(1.1 * ones(10), zeros(10, 4)) + rand(10, 5)  # 10 points in 5D, shifted  by a bit

    result = separating_hyperplane(P, Q)
    @test result.status == :Separable

end
