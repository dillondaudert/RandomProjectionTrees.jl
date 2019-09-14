module RandomProjectionTrees

using StatsBase: sample
using LinearAlgebra: adjoint

include("tree.jl")
include("split.jl")
include("utils.jl")

export RandomProjectionTree, search_rptree

end # module
