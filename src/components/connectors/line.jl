struct ConnectorLine <: Connector
end

function _plot_connector!(p, annotation::Annotation{S,E,N,ST,CT}) where {S,E,N,ST,CT<:ConnectorLine}
    lines!(p, [annotation.subject, annotation.endpoint])
end

function direction(p1, p2; normalize=true)
    dir = p1 + p2

    if normalize
        dir = dir / norm(dir)
    end

    return dir
end
