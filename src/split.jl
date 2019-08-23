
const EPSILON = 1e-8

function rp_split(data, indices, metric::Euclidean)

    # select two random points and set the hyperplane between them
    leftidx, rightidx = sample(indices, 2; replace=false)
    hyperplane = data[leftidx] .- data[rightidx]
    offset = 0
    for d in eachindex(hyperplane)
        offset -= dot(hyperplane[d], (data[leftidx][d] + data[rightidx][d])/2)
    end
    # offset = -(dot(hyperplane, (data[leftidx] .+ data[rightidx])./2))
    sides = Array{Bool}(undef, length(indices))
    for i, idx in enumerate(indices)
        margin = offset + dot(hyperplane, data[idx])
        if norm(margin) < EPSILON
            if rand() < .5
                sides[i] = true
            else
                sides[i] = false
            end
        elseif margin
    end
end
