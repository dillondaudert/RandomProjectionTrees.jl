
"""
    rp_split(data, indices) -> lefts, rights, hyperplane, offset

Splits the data into two sets depending on which side of a random hyperplane
each point lies.
Returns the left indices, right indices, hyperplane, and offset.
"""
function rp_split(data, indices)

    # select two random points and set the hyperplane between them
    # TODO: threading
    # TODO: remove StatsBase dep
    leftidx, rightidx = sample(indices, 2; replace=false)
    hyperplane = data[leftidx] - data[rightidx]

    offset = -adjoint(hyperplane) * (data[leftidx] + data[rightidx]) / 2

    lefts = sizehint!(Int32[], div(length(data), 2))
    rights = sizehint!(Int32[], div(length(data), 2))
    # TODO: threading
    for (i, idx) in enumerate(indices)
        # for each data vector, compute which side of the hyperplane
        select_side(hyperplane, offset, data[idx]) ? append!(lefts, idx) : append!(rights, idx)
    end

    return lefts, rights, hyperplane, offset
end

"""
Project `point` onto `hyperplane` and return `true` if it lies to the "left" of
`offset`, otherwise return `false`.
If the point is less than `√eps`, pick a side randomly.
"""
function select_side(hyperplane, offset, point)
    margin = adjoint(hyperplane) * point + offset
    if abs(margin) <= sqrt(eps(margin))
        # TODO: threading
        return rand() < .5
    end
    return margin < 0
end
