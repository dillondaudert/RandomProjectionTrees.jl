

function rp_split(data::U, indices) where {T <: Number,
                                           V <: AbstractVector{T},
                                           U <: AbstractVector{V}}
    """
    Splits the data into two sets depending on which side of a random hyperplane
    each point lies.
    Returns the left indices, right indices, hyperplane, and offset.
    """

    # select two random points and set the hyperplane between them
    leftidx, rightidx = sample(indices, 2; replace=false)
    hyperplane = data[leftidx] - data[rightidx]

    offset = -adjoint(hyperplane) * (data[leftidx] + data[rightidx]) / 2

    lefts = Int[]
    rights = Int[]
    for (i, idx) in enumerate(indices)
        # for each data vector, compute which side of the hyperplane
        margin = real(adjoint(hyperplane) * data[idx] + offset)
        if abs(margin) < sqrt(eps(margin))
            if rand() < .5
                append!(lefts, idx)
            else
                append!(rights, idx)
            end
        elseif margin < 0
            append!(lefts, idx)
        else
            append!(rights, idx)
        end
    end

    return lefts, rights, hyperplane, offset
end
