function covMatrix = constructCovMatrix(covCell)
%CONSTRUCTCOVMATRIX Block diagonal of a cell of matrices.
% inputs:
%   covCell             Cell of covariance matrices.
% outputs:
%   covMatrix           Covariance matrix.

    %% Construct covariance
    covMatrix = blkdiag(covCell{:});  
end

