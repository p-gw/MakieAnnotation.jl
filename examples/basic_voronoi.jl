using CairoMakie
using MakieAnnotation
using Random

Random.seed!(57394)

set_theme!(
    textcolor=:black,
    markersize=6,
    fontsize=10,
    textsize=10
)

n = 150

pts = [Point(randn(), randn()) for _ in 1:n]
labs = string.(eachindex(pts))


# labels only
f1, ax1 = scatter(pts, color=:black)
voronoilabels!(pts, labs, cutoff=0.2)

hidedecorations!(ax1)
hidespines!(ax1)
limits!(ax1, -3, 3, -3, 3)

save("examples/figure/basic_voronoi.png", f1)

# with voronoi diagram
f2, ax2 = scatter(pts, color=:black)
voronoilabels!(pts, labs, cutoff=0.2, debug=true)

hidedecorations!(ax2)
hidespines!(ax2)
limits!(ax2, -3, 3, -3, 3)

save("examples/figure/basic_voronoi_debug.png", f2)
