
struct RandomProjectionTreeNode{T <: Number,
                                V <: AbstractVector{T}}
    indices
    isleaf::Bool
    hyperplane::Union{V, Nothing}
    offset::Union{T, Nothing}
    leftchild::Union{RandomProjectionTreeNode{T, V}, Nothing}
    rightchild::Union{RandomProjectionTreeNode{T, V}, Nothing}
end


struct RandomProjectionTree{T <: Number, V <: AbstractVector{T}}
    root::RandomProjectionTreeNode{T, V}
    leafsize
end

"""
    RandomProjectionTree(data; leafsize = 30)

A RandomProjectionTree is a binary tree whose non-leaf nodes correspond to random
hyperplanes in ℜᵈ and whose leaf nodes represent subregions that partition this
space.
"""
function RandomProjectionTree(data; leafsize = 30)
    root = build_rptree(data, 1:length(data), leafsize)
    return RandomProjectionTree(root, leafsize)
end


"""
    build_rptree(data::AbstractVector, indices, leafsize) -> RandomProjectionTreeNode

Recursively construct the RP tree by randomly splitting the data into nodes.
"""
function build_rptree(data::U, indices, leafsize) where {T <: Number,
                                                         V <: AbstractVector{T},
                                                         U <: AbstractVector{V}}
    if length(indices) <= leafsize
        return RandomProjectionTreeNode{T, V}(indices,
                                              true,
                                              nothing,
                                              nothing,
                                              nothing,
                                              nothing)
    end

    leftindices, rightindices, hyperplane, offset = rp_split(data, indices)
    leftchild = build_rptree(data, leftindices, leafsize)
    rightchild = build_rptree(data, rightindices, leafsize)

    return RandomProjectionTreeNode(nothing,
                                    false,
                                    hyperplane,
                                    offset,
                                    leftchild,
                                    rightchild)
end


"""
    search_tree(tree, point) -> node::RandomProjectionTreeNode

Search a random projection tree for the node to which a point belongs.
"""
function search_rptree(tree::RandomProjectionTree{T, V},
                       point::V
                       ) where {T, V}

    node = tree.root
    while !node.isleaf
        node = select_side(node.hyperplane, node.offset, point) ? node.leftchild : node.rightchild
    end
    return node

end

#############################
# Random Projection Forests
#############################

struct RandomProjectionForest{T, V}
    trees::Vector{RandomProjectionTree{T, V}}
end

"""
    RandomProjectionForest(data, args...; n_trees, kwargs...) -> RandomProjectionForest

Create a collection of `n_trees` random projection trees built using `data`.
`args...` and `kwargs...` are passed to the RandomProjectionTree constructor.
"""
function RandomProjectionForest(data, args...;
                                n_trees, kwargs...)
    # TODO: threading
    trees = [RandomProjectionTree(data, args...; kwargs...) for _ in 1:n_trees]
    return RandomProjectionForest(trees)
end

"""
    approx_knn(tree, data, point, n_neighbors) -> indices, distances

Find approximate nearest neighbors to `point` in `data` using a random
projection tree built on this data. Returns the indices and distances to the
approximate knns as arrays, sorted by distance.
"""
function approx_knn(tree::RandomProjectionTree,
                    data,
                    point,
                    n_neighbors)
    # TODO: handle case when n_neighbors > tree.leafsize
    candidates = search_rptree(tree, point).indices

    return _approx_knn(data, point, candidates, n_neighbors)
end

"""

"""
function approx_knn(forest::RandomProjectionForest,
                    data,
                    point,
                    n_neighbors)
    # TODO: threading
    candidates = []
    for tree in forest.trees
        union!(candidates, search_rptree(tree, point).indices)
    end
    return _approx_knn(data, point, candidates, n_neighbors)
end

"""

"""
function _approx_knn(data, point, candidates, n_neighbors)
    length(candidates) >= n_neighbors || @warn "Fewer candidates than n_neighbors!"
    # TODO: threading
    distances = [norm(data[i] - point) for i in candidates]
    perm = sortperm(distances)
    indices = candidates[perm]
    distances = distances[perm]

    if n_neighbors < length(indices)
        indices = indices[1:n_neighbors]
        distances = distances[1:n_neighbors]
    end
    return indices, distances
end
