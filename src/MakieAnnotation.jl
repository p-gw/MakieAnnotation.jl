module MakieAnnotation

using Colors
using GeometryBasics
using Makie
using VoronoiCells

export Rectangle
export voronoi!, voronoi, voronoilabels!, voronoilabels

include("voronoilabels.jl")

end
