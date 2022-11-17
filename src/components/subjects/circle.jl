struct SubjectCircle{T<:Real,V<:Real} <: Subject
    size::T
    padding::V
end

function SubjectCircle(; size=40, padding=10)
    return SubjectCircle{typeof(size),typeof(padding)}(size, padding)
end

function _plot_subject!(p, annotation::Annotation{S,E,N,ST,CT}) where {S,E,N,ST<:SubjectCircle,CT}
    scatter!(p, annotation.subject,
        marker=:circle,
        markersize=annotation.subject_type.size,
        strokecolor=DEFAULT_COLOR,
        strokewidth=1,
        color=(:black, 0)
    )
end
