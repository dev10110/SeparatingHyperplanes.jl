# SeparatingHyperplanes

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://dev10110.github.io/SeparatingHyperplanes.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://dev10110.github.io/SeparatingHyperplanes.jl/dev/)
[![Build Status](https://github.com/dev10110/SeparatingHyperplanes.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/dev10110/SeparatingHyperplanes.jl/actions/workflows/CI.yml?query=branch%3Amain)


Given two sets of points `P`, `Q`, this package exports the function 

```
    using SeparatingHyperplanes
    result = separating_hyerplane(P, Q)

    status = result.status
    a, b = result.a, result.b
```

such that the hyperplane   `a z = b` separates the points, if one exists. The `status` field defines whether the points can be separated. 

See the documentation for additional details. 