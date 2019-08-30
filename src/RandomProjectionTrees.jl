module RandomProjectionTrees

using StatsBase: sample
using LinearAlgebra: adjoint, norm

include("utils.jl")
include("tree.jl")
include("split.jl")

export RandomProjectionTree

end # module
