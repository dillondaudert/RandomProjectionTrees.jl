
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

function RandomProjectionTree(data; leafsize = 30)
    root = build_rptree(data, 1:length(data), leafsize)
    return RandomProjectionTree(root)
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
