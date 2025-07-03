module SeparatingHyperplanes

using LinearAlgebra, SparseArrays, OSQP

export separating_hyperplane

"""
    Result{F}

Results struct containg 
- `status`: Symbol indicating the status of the solution
- `a`: Vector of coefficients for the hyperplane
- `b`: Scalar offset for the hyperplane
- `separating_distance`: Distance between the two sets of points
- `osqp_result`: The raw OSQP result object containing detailed solver information

This struct is used to encapsulate the results of the `separating_hyperplane` function.

The solver status can be one of the following:
- `:Separable`: The sets are separable with a valid hyperplane.
- `:Not_separable`: The sets are not separable.
- `:Separable_inaccurate`: The sets are separable, but the solution is inaccurate.
- `:Not_separable_inaccurate`: The sets are not separable, but the solution is inaccurate.
- `:Max_iter_reached`: The solver reached the maximum number of iterations without convergence.
- `:Time_limit_reached`: The solver reached the time limit without convergence.
- `:Interrupted`: The solver was interrupted before completion.
- `:Unknown`: The status is unknown or not recognized.
"""
struct Result{F}
    status::Symbol
    a::Vector{F}
    b::F
    separating_distance::F
    osqp_result::OSQP.Results
end

# Map OSQP status codes to relevant symbols for the Result
const status_map = Dict{Symbol,Symbol}(
    :Dual_infeasible_inaccurate => :Not_separable_inaccurate,
    :Primal_infeasible_inaccurate => :Not_separable_inaccurate,
    :Solved_inaccurate => :Separable_inaccurate,
    :Solved => :Separable,
    :Max_iter_reached => :Max_iter_reached,
    :Primal_infeasible => :Not_separable,
    :Dual_infeasible => :Not_separable,
    :Interrupted => :Interrupted,
    :Time_limit_reached => :Time_limit_reached,
    :Non_convex => :Unknown,
    :Unsolved => :Unknown,
)

"""
    separating_hyperplane(P, Q; eps_abs=1e-10, eps_rel=1e-10, verbose=false, kwargs...)

Find a separating hyperplane between two sets of points P and Q in R^d.
If a separating hyperplane exists, it returns a Result object containing the hyperplane parameters and the distance between the sets.

Arguments:
- `P`: A matrix of points in R^d, arranged as N x d matrix
- `Q`: A matrix of points in R^d, arranged as N x d matrix
- `eps_abs`: Absolute tolerance for the OSQP solver (default: 1e-10)
- `eps_rel`: Relative tolerance for the OSQP solver (default: 1e-10)
- `verbose`: If true, prints solver information (default: false)
- `kwargs`: Additional keyword arguments for the OSQP solver
Returns:
- A `Result` struct. 

This solves the problem 
```math
\\begin{align*}
    \\underset{a \\in \\mathbb{R}^d, b \\in \\mathbb{R}}{\\operatorname{minimize}} \\quad  & \\frac{1}{2} \\Vert a \\Vert^2\\\\
    \\operatorname{s.t.} \\quad  & a^T p_i - b \\geq 1 \\quad \\forall p_i \\in P \\\\
         & a^T q_i - b \\leq -1 \\quad \\forall q_i \\in Q 
\\end{align*}
```

If the sets are separable, the hyperplane slab ``-1 \\leq a^T z - b \\leq 1`` separates the two point sets.
The distance between the sets is given by `2 / norm(a)`.
"""
function separating_hyperplane(
    P,
    Q;
    eps_abs = 1e-10,
    eps_rel = 1e-10,
    verbose = false,
    kwargs...,
)
    np, dp = size(P)
    nq, dq = size(Q)
    d = dp

    @assert d > 0 "Points must be in at least 1D space."
    @assert dp == dq "Points in both sets must have the same dimension."
    @assert np > 0 && nq > 0 "Both sets must contain at least one point."

    # construct cost matrices
    P_ = spzeros(d + 1, d+1)
    for i = 1:d
        P_[i, i] = 1
    end
    q_ = zeros(d+1)

    # construct constraints
    A_ = sparse(hcat(vcat(P, Q), -ones(np + nq)))
    l_ = vcat(ones(np), -Inf * ones(nq))
    u_ = vcat(Inf * ones(np), -ones(nq))

    # create the OSQP model
    model = OSQP.Model()
    OSQP.setup!(
        model;
        P = P_,
        q = q_,
        A = A_,
        l = l_,
        u = u_,
        verbose = verbose,
        eps_abs = eps_abs,
        eps_rel = eps_rel,
        kwargs...,
    )

    # solve the problem
    osqp_results = OSQP.solve!(model)

    # extract results
    status = get(status_map, osqp_results.info.status, :Unknown)
    a = osqp_results.x[1:d][:]
    b = osqp_results.x[d+1]
    separating_distance = 2 / norm(a)

    # construct the result
    result = Result(status, a, b, separating_distance, osqp_results)

    return result
end


end
