struct VoronoiCell{PT<:AbstractPoint}
    vertices::Vector{PT}
    centroid::PT
    data::PT
    area::Float64
end

"""
    voronoilabels(positions, labels; attributes...)
    voronoilabels!(positions, labels; attributes...)

Annotate a scatter plot using labels derived from a Voronoi diagram.

# Plot attributes
- `boundingbox`: The outer bounding box of the voronoi diagram in data units. default: nothing
- `cutoff`: The area cutoff for label display in data unit. If `area(cell) >= cutoff` the label will be displayed. default: 1
- `textsize`: The textsize of the labels in pixels. default: 12
- `debug`: Enable debug mode to display the Voronoi diagram in the plot. default: false
"""
Makie.@recipe(VoronoiLabels, positions, labels) do scene
    Attributes(;
        boundingbox=nothing,
        debug=false,
        cutoff=1,
        textsize=12
    )
end

function Makie.plot!(p::VoronoiLabels)
    if isnothing(p.boundingbox[])
        error("Please provide a valid bounding box.")
    end

    positions = p[1]
    labels = p[2]

    voronoi = voronoi_grid(positions[], p.boundingbox[])

    if p.debug[]
        voronoi!(p, voronoi)
    end

    for (i, cell) in enumerate(voronoi)
        if cell.area >= p.cutoff[]
            position = cell.data
            alignment = xalignment(cell)
            offset = label_offset(alignment)
            align = label_alignment(alignment)

            text!(p, position; text=labels[][i], offset, align, textsize=p.textsize[])
        end
    end


    return p
end

function xangle(cell::VoronoiCell)
    direction = cell.centroid - cell.data
    angle_rad = atan(direction[2], direction[1])
    return angle_rad
end

"""
    xalignment(angle)

Calculate the label alignment with respect to the data point.

- 0: right
- 1: bottom
- 2: left
- 3: top
"""
function xalignment(cell::VoronoiCell)
    angle_rad = xangle(cell)
    alignment = (round(angle_rad / pi * 2) + 4) % 4
    return alignment
end

function label_offset(alignment)
    if alignment == 0
        return (6, 0)
    elseif alignment == 1
        return (0, 3)
    elseif alignment == 2
        return (-6, 0)
    elseif alignment == 3
        return (0, -3)
    end
end

function label_alignment(alignment)
    if alignment == 0
        return (:left, :center)
    elseif alignment == 1
        return (:center, :bottom)
    elseif alignment == 2
        return (:right, :center)
    elseif alignment == 3
        return (:center, :top)
    end
end

Makie.@recipe(Voronoi) do scene
    Attributes(;
        color=colorant"#2dd4bf",
        gridcolor=colorant"#d1d5db"
    )
end

function Makie.plot!(p::Voronoi{<:Tuple{Vector{VoronoiCell}}})
    cells = p[1]
    vertices = getfield.(cells[], :vertices)
    centroids = getfield.(cells[], :centroid)
    positions = getfield.(cells[], :data)

    lines = [(centroids[i], positions[i]) for i in eachindex(centroids)]

    poly!(p, vertices, strokecolor=p.gridcolor[], color=(:black, 0), strokewidth=0.5)
    linesegments!(p, lines, color=p.color[], strokewidth=0.5)
    scatter!(p, centroids, color=p.color[])

    return p
end

function voronoi_grid(positions, boundingbox::Rectangle)
    tesselation = voronoicells(positions, boundingbox)
    cells = tesselation.Cells

    voronoi = Vector{VoronoiCell}(undef, length(cells))
    for (i, cell) in enumerate(cells)
        center = centroid(cell)
        area = GeometryBasics.area(cell)
        voronoi[i] = VoronoiCell(cell, center, positions[i], area)
    end

    return voronoi
end

function centroid(polygon)
    center = sum(polygon) / length(polygon)
    return center
end

