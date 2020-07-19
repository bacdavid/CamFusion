function distance = mahalDistance(x, y, cov)
%MAHALDISTANCE Compute the Mahalanobis distance. x and y can be m x n
%matrices where n is the dimensionality of the feature and m is the batch
%size. 
% inputs:
%   x                   First entry.
%   y                   Second entry.
%   cov                 Covariance matrix.
% outputs:
%   distance            Result.

%% Compute Mahalanobis distance
    v = x - y;
    distance = diag(v * inv(cov) * v');
end