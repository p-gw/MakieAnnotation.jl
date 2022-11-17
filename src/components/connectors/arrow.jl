struct EndArrow{ST<:AbstractPoint,T<:Real,U<:Real} <: EndPoint
    subject::ST
    markersize::T
    rotation::U
end

function _plot_endpoint!(ax::Axis, endpoint::EndArrow; kwargs...)
    scatter!(ax, endpoint.subject, markersize=endpoint.markersize, marker=:utriangle, rotations=endpoint.rotation)
end
