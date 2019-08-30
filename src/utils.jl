
sizeof(t::RandomProjectionTree) = sizeof(t.root)

sizeof(n::RandomProjectionTreeNode) = sizeof(n.indices) + sizeof(n.isleaf) +
                                      sizeof(n.hyperplane) + sizeof(n.offset) +
                                      sizeof(n.leftchild) + sizeof(n.rightchild)

num_nodes(t::RandomProjectionTree) = num_nodes(t.root)

function num_nodes(n::RandomProjectionTreeNode)::Int
    n.isleaf || 1 + num_nodes(n.leftchild) + num_nodes(n.rightchild)
end

num_leaves(t::RandomProjectionTree) = num_leaves(t.root)

function num_leaves(n::RandomProjectionTreeNode)::Int
    n.isleaf || num_leaves(n.leftchild) + num_leaves(n.rightchild)
end

leaves(t::RandomProjectionTree) = leaves(t.root)

function leaves(n::RandomProjectionTreeNode)

    n.isleaf && return [n]
    return append!(leaves(n.leftchild), leaves(n.rightchild))
end
