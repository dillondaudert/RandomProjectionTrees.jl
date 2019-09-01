
sizeof(t::RandomProjectionTree) = sizeof(t.root)

sizeof(n::RandomProjectionTreeNode) = sizeof(n.indices) + sizeof(n.isleaf) +
                                      sizeof(n.hyperplane) + sizeof(n.offset) +
                                      sizeof(n.leftchild) + sizeof(n.rightchild)

num_nodes(t::RandomProjectionTree) = num_nodes(t.root)

function num_nodes(n::RandomProjectionTreeNode)
    n.isleaf || true + num_nodes(n.leftchild) + num_nodes(n.rightchild)
end

num_leaves(t::RandomProjectionTree) = num_leaves(t.root)

function num_leaves(n::RandomProjectionTreeNode)
    n.isleaf || num_leaves(n.leftchild) + num_leaves(n.rightchild)
end

leaves(t::RandomProjectionTree) = leaves(t.root)

function leaves(n::RandomProjectionTreeNode)

    n.isleaf && return [n]
    return append!(leaves(n.leftchild), leaves(n.rightchild))
end

"""
    search_tree(tree, point) -> node

Search a random projection tree for the node to which a point belongs.
"""
function search_tree(tree::RandomProjectionTree{T, V},
                     point::V
                     ) where {T, V}

    node = tree.root
    while !node.isleaf

    end

    return node

end
