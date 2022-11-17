struct EndDot{ST<:AbstractPoint,T<:Real} <: EndPoint
    subject::ST
    markersize::T
end

function _plot_endpoint!(ax::Axis, endpoint::EndDot; kwargs...)
    scatter!(ax, endpoint.subject, markersize=endpoint.markersize)
end
