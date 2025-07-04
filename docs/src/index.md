```@meta
CurrentModule = SeparatingHyperplanes
```

# Separating Hyperplanes

Documentation for [SeparatingHyperplanes.jl](https://github.com/dev10110/SeparatingHyperplanes.jl).

Mathematical details can be found in [Convex Optimization by Boyd and Vandenberghe](https://web.stanford.edu/~boyd/cvxbook/), Section 8.6.1.
Eventually, I intend to add in further functionality, e.g., a soft separating hyperplane. 


## Example
```@setup main
using Random
Random.seed!(0)
```

```@example main
using SeparatingHyperplanes

# create two 2D pointclouds
P = rand(10, 2) 
Q = 1.0 * ones(20, 2) + rand(20, 2)

# find a separating hyperplane
result = separating_hyperplane(P, Q)

# get the status
status = result.status
```

```@example main
# get the hyperplane
a, b = result.a, result.b
```

```@example main
# get the separating distance
d = result.separating_distance
```

We can now plot the results (for 2D):
```@example main
using Plots

# Plots the hyerplane a' x = b
function plot_hyperplane!(a, b; tlims = (-1, 1), kwargs...)
        @assert length(a) == 2 "this function only works in 2D"
        # find one point on the plane
        x0 = (b / (a' * a)) * a
        # find the tangential vector
        n = [-a[2], a[1]]
        plot!(t-> (x0 + t * n)[1], t-> (x0 + t * n)[2], tlims...; kwargs...)
end

plot()
scatter!(P[:, 1], P[:, 2], label="P")
scatter!(Q[:, 1], Q[:, 2], label="Q")
plot_hyperplane!(a, b; tlims=(-0.5, 0.5), label="a'z = b")
```


## API
```@autodocs
Modules = [SeparatingHyperplanes]
```
