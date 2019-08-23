
struct RandomProjectionTreeNode{T <: Number,
                                V <: AbstractVector{T}}
    indices::Union{Array{Integer}, Nothing}
    isleaf::Bool
    hyperplane::Union{V, Nothing}
    offset::Union{T, Nothing}
    leftchild::Union{RandomProjectionTreeNode{T, V}, Nothing}
    rightchild::Union{RandomProjectionTreeNode{T, V}, Nothing}
end

struct RandomProjectionTree{M <: PreMetric, T <: Number, V <: AbstractVector{T}}
    root::RandomProjectionTreeNode{T, V}
    metric::M
end

function RandomProjectionTree(data::AbstractVector{V},
                              metric::PreMetric,
                              leafsize::Integer = 30,
                              ) where V
    indices = 1:size(data, 2)
    root = build_rptree(data, indices, metric, leafsize)

    return RandomProjectionTree(root, metric)
end

function build_rptree(data, indices, metric, leafsize)
    if length(indices) <= leafsize
        return RandomProjectionTreeNode(indices,
                                        true,
                                        nothing,
                                        nothing,
                                        nothing,
                                        nothing)


    leftindices, rightindices, hyperplane, offset = rp_split(data, indices, metric)
    leftchild = build_rptree(data, leftindices, metric, leafsize)
    rightchild = build_rptree(data, rightindices, metric, leafsize)

    return RandomProjectionTreeNode(nothing,
                                    false,
                                    hyperplane,
                                    offset,
                                    leftchild,
                                    rightchild)
end
