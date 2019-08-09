
function MakeTree(data::AbstractVector{V},
                  leafsize::Integer,
                  ) where {S, V <: AbstractVector{S}}

    if length(data) < leafsize
        return Leaf
    end

    Rule = ChooseRule(data)
    data_mask = Rule(data)
    LeftTree = MakeTree(data[data_mask])
    RightTree = MakeTree(data[(!).data_mask])
    return [Rule, LeftTree, RightTree]
end
