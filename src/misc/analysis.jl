# various functions for analyzing the performance characteristics of RP trees

function local_cov_dim(eigs, eps) 
    d = 1
    while !has_local_cov_dim(eigs, d, eps)
        d += 1
    end
    return d
end

has_local_cov_dim(eigs, d, eps) = sum(eigs[end-(d-1):end].^2) >= (1 - eps)*sum(eigs.^2)
