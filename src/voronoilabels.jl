struct VoronoiCell{PT<:AbstractPoint}
    vertices::Vector{PT}
    centroid::PT
    data::PT
    area::Float64
end

Makie.@recipe(VoronoiLabels) do scene
    Attributes(;
        debug=false,
        cutoff=1,
        textsize=12
    )
end

function Makie.plot!(p::VoronoiLabels)
    scene = Makie.parent_scene(p)
    limits = lift(Makie.projview_to_2d_limits, scene.camera.projectionview)

    voronoi = Observable(VoronoiCell[])
    label_positions = Observable(Point2f[])
    label_aligns = Observable(Tuple[])
    label_offsets = Observable(Tuple[])
    label_visibility = Observable(Bool[])
    labels = p[2]

    onany(limits, p[1]) do lims, positions
        empty!(voronoi[])
        empty!(label_positions[])
        empty!(label_aligns[])
        empty!(label_offsets[])
        empty!(label_visibility[])

        bb = bounding_rect(positions, lims)

        append!(voronoi[], voronoi_grid(positions, bb))

        extent = extrema(lims)
        xmin, xmax = first.(extent)
        ymin, ymax = last.(extent)

        for cell in voronoi[]
            isvisible = (cell.area >= p.cutoff[]) && (xmin < first(cell.data) < xmax) && (ymin < last(cell.data) < ymax)
            alignment = xalignment(cell)
            offset = label_offset(alignment)
            align = label_alignment(alignment)

            push!(label_positions[], cell.data)
            push!(label_offsets[], offset)
            push!(label_aligns[], align)
            push!(label_visibility[], isvisible)
        end

        notify(voronoi)
        notify(label_positions)
        notify(label_offsets)
        notify(label_aligns)
        notify(label_visibility)
    end

    notify(p[1])  # init plotting

    if p.debug[]
        voronoi!(p, voronoi; p.attributes...)
    end

    label_plots = Vector{Makie.Text}(undef, length(labels[]))

    for i in eachindex(labels[])
        pos = label_positions[][i]
        text = labels[][i]
        offset = label_offsets[][i]
        visible = label_visibility[][i]
        align = label_aligns[][i]
        label_plots[i] = text!(p, pos; text, offset, align, visible, textsize=p.textsize[])
    end

    on(label_positions) do l
        for (i, lp) in enumerate(label_plots)
            lp.position[] = l[i]
        end
    end

    on(label_offsets) do l
        for (i, lp) in enumerate(label_plots)
            lp.offset[] = l[i]
        end
    end

    on(label_aligns) do l
        for (i, lp) in enumerate(label_plots)
            lp.align[] = l[i]
        end
    end

    on(label_visibility) do l
        for (i, lp) in enumerate(label_plots)
            lp.visible[] = l[i]
        end
    end

    return p
end

function bounding_rect(positions, rect::HyperRectangle{2,<:Real})
    # check if all points are inside rect
    xmin, ymin = rect.origin
    xmax, ymax = rect.origin + rect.widths

    xmin_rect = min(xmin, minimum(first, positions))
    ymin_rect = min(ymin, minimum(last, positions))

    xmax_rect = max(xmax, maximum(first, positions))
    ymax_rect = max(ymax, maximum(last, positions))

    p1 = Point{2,Float64}(xmin_rect, ymin_rect)
    p2 = Point{2,Float64}(xmax_rect, ymax_rect)
    return Rectangle(p1, p2)
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
        gridcolor=colorant"#d1d5db",
        xautolimits=false,
        yautolimits=false
    )
end

function Makie.plot!(p::Voronoi{<:Tuple{Vector{VoronoiCell}}})
    centroids = lift(x -> getfield.(x, :centroid), p[1])
    vertices = lift(x -> getfield.(x, :vertices), p[1])
    positions = lift(x -> getfield.(x, :data), p[1])
    lines = lift((x, y) -> [(x[i], y[i]) for i in eachindex(x)], centroids, positions)

    notify(p[1])

    poly!(p, vertices; p.attributes..., strokecolor=p.gridcolor[], color=(:black, 0), strokewidth=1)
    linesegments!(p, lines; p.attributes...)
    scatter!(p, centroids; p.attributes...)

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

