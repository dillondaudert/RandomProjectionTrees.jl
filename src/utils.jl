
sizeof(t::RandomProjectionTree) = sizeof(t.root)

sizeof(n::RandomProjectionTreeNode) = sizeof(n.indices) + sizeof(n.isleaf) +
                                      sizeof(n.hyperplane) + sizeof(n.offset) +
                                      sizeof(n.leftchild) + sizeof(n.rightchild)
