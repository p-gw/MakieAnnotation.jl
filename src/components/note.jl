struct Note <: AnnotationComponent
    anchor
    content
    align
end

function _plot_note!(ax::Axis, note::Note)
    label = text!(ax, note.anchor, text=note.content, align=note.align, justification=:left, visible=false)
    bb = boundingbox(label)
    bb_padded = add_padding(bb, 10)
    poly!(ax, bb_padded, color=(DEFAULT_COLOR, 0.1), space=:pixel)
    return label
end

function add_padding(rect::HyperRectangle, padding::Real)
    padded_widths = rect.widths .+ 2 * padding
    new_origin = rect.origin .- padding
    return HyperRectangle(new_origin, padded_widths)
end
