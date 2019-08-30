
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
end

function RandomProjectionTree(data,
                              leafsize = 30,
                              )
    indices = 1:length(data)
    root = build_rptree(data, indices, leafsize)

    return RandomProjectionTree(root)
end

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
