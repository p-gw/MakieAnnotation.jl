module MakieAnnotation

using Colors
using GeometryBasics
using LinearAlgebra
using Makie
using VoronoiCells

export Rectangle
export voronoi!, voronoi, voronoilabels!, voronoilabels
export Annotation

const DEFAULT_COLOR = colorant"#2dd4bf"
const DEFAULT_LINEWIDTH = 0.5

include("types.jl")

# include("voronoilabels.jl")
# include("annotation.jl")


# include("components/connectors/dot.jl")
# include("components/connectors/arrow.jl")

# include("components/subjects/circle.jl")

# include("components/note.jl")

include("annotation.jl")

include("components/connectors/line.jl")

include("components/subjects/none.jl")
include("components/subjects/circle.jl")

const DEFAULT_SUBJECT = nothing
const DEFAULT_CONNECTOR = ConnectorLine()

end
