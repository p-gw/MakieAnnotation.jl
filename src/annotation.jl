#=

Definitions:

1. subject: the endpoint of the annotation

2. connector: the connecting line/arrow of the annotation
    line
    arrow

3. label: the text/textbox of the annotation
=#

struct Annotation{S<:AbstractPoint,E<:AbstractPoint,N<:AbstractString,ST<:Union{Nothing,Subject},CT<:Connector}
    subject::S
    endpoint::E
    note::N
    subject_type::ST
    connector_type::CT
    offset::Bool
end

function Annotation(subject::S, endpoint::E, note::N; subject_type::ST=DEFAULT_SUBJECT, connector_type::CT=DEFAULT_CONNECTOR, offset=false, padding=20) where {S,E,N,ST,CT}
    if offset
        endpoint = endpoint + subject
    end

    return Annotation{S,E,N,ST,CT}(subject, endpoint, note, subject_type, connector_type, offset)
end

function annotation!(ax::Axis, annotation::Annotation)
    _plot_subject!(ax, annotation)
    _plot_connector!(ax, annotation)
    return ax
end

annotation!(annotation::Annotation) = annotation!(current_axis(), annotation)



Makie.@recipe(_Annotation) do scene
    Attributes(
        color=:red
    )
end

function Makie.plot!(p::_Annotation)

    @show scene = Makie.parent_scene(p)
    @show lift(Makie.projview_to_2d_limits, scene.camera.projectionview)


    annotation = p[1]

    # plot subject
    _plot_subject!(p, annotation[])
    _plot_connector!(p, annotation[])

    return p
end
