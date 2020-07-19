function [y, P, Q, R] = initializeFilter(kalmanParameters)
%INITIALIZEFILTER Extract initial values from the kalman parameters.
% inputs:
%   kalmanParameters    Kalman parameters as described in the rest of
%                       library.
% outputs:
%   y                   Initial state value.
%   P                   Initial covariance.
%   Q                   Process covariance.
%   R                   Measurement covariance.

    %% Initialize filter
    y = constructStateVector(kalmanParameters.mu);
    P = constructCovMatrix(kalmanParameters.sigma);
    Q = blkdiag(kalmanParameters.Q{:});
    R = blkdiag(kalmanParameters.R{:});
end