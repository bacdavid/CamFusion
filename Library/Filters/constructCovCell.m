function covCell = constructCovCell(covMatrix, kalmanParameters)
%CONSTRUCTCOVCELL Decompose the covariance matrix into cells of matrices.
%Note that this only works with decoupled states, resp. the covariance
%matrix has to be block-diagonal.
% inputs:
%   covMatrix           Any block-diagonal covariance matrix.
%   kalmanParameters    Kalman parameters as described in the rest of
%                       library.
% outputs:
%   covCell             Decomposed covariance matrix.

    %% Decompose covariance
    covCell = cell(size(kalmanParameters.sigma, 1), 1);
    idx = 1;
    for i = 1 : size(kalmanParameters.sigma, 1)
        covCell{i} = covMatrix(idx : idx + size(kalmanParameters.sigma{i}, 1) - 1, idx : idx + size(kalmanParameters.sigma{i}, 1) - 1);
        idx = idx + size(kalmanParameters.sigma{i}, 1);
    end
end