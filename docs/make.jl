using MakieAnnotation
using Documenter

DocMeta.setdocmeta!(MakieAnnotation, :DocTestSetup, :(using MakieAnnotation); recursive=true)

makedocs(;
    modules=[MakieAnnotation],
    authors="Philipp Gewessler",
    repo="https://github.com/p-gw/MakieAnnotation.jl/blob/{commit}{path}#{line}",
    sitename="MakieAnnotation.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://p-gw.github.io/MakieAnnotation.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/p-gw/MakieAnnotation.jl",
    devbranch="main",
)
