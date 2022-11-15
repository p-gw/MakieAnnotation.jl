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

# Voronoi labels
n = 150
pts = [Point(randn(), randn()) for _ in 1:n]
bb = Rectangle(Point(-6, -6), Point(6, 6))

function voronoi_example(; debug=true)
    f = Figure()
    ax = Axis(f[1, 1])

    voronoilabels!(ax, pts, string.(eachindex(pts)), boundingbox=bb, cutoff=0.2, debug=debug)
    scatter!(ax, pts, color=:black)

    hidedecorations!(ax)
    hidespines!(ax)

    limits!(ax, -4, 4, -4, 4)

    return f
end

v1 = voronoi_example(debug=false)
v2 = voronoi_example(debug=true)

save("docs/figure/voronoi.png", v1)
save("docs/figure/voronoi_debug.png", v2)
