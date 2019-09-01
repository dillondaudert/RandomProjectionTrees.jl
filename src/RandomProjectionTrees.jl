module RandomProjectionTrees

using StatsBase: sample
using LinearAlgebra: adjoint, norm

include("tree.jl")
include("split.jl")
include("utils.jl")

export RandomProjectionTree

end # module
