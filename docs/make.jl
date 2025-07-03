using SeparatingHyperplanes
using Documenter

DocMeta.setdocmeta!(
    SeparatingHyperplanes,
    :DocTestSetup,
    :(using SeparatingHyperplanes);
    recursive = true,
)

makedocs(;
    modules = [SeparatingHyperplanes],
    authors = "Devansh Agrawal <devansh@umich.edu> and contributors",
    sitename = "SeparatingHyperplanes.jl",
    format = Documenter.HTML(;
        canonical = "https://dev10110.github.io/SeparatingHyperplanes.jl",
        edit_link = "main",
        assets = String[],
    ),
    pages = ["Home" => "index.md"],
)

deploydocs(; repo = "github.com/dev10110/SeparatingHyperplanes.jl", devbranch = "main")
