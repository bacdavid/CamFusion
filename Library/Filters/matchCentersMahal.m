function matchedCenters = matchCentersMahal(proposedCenters, predictedCenters, predictedCov, pThresh)
%DEPRECATED!
%MATCHCENTERSMAHAL Match proposed object centers (or any points in 3
%dimensions) with a set of predicted centers. Have a look at
%MATCHCENTERSL2.
% inputs:
%   proposedCenters     Proposed centers or any 3dim points.
%   predictedCenters    Predicted centers.
%   predictedCov        Covariance to use for Mahalanobis distance.
%   pThresh             Threshold for outliers.
% outputs:
%   matchedCenters      Index pairs, where the first index corresponds to
%                       the proposed center and second to the predicted.

    %% Match centers
     % If no centers have been measured
     if isempty(proposedCenters{1})
         matchedCenters = double.empty(0, 2);
         return;
     end
    
    % Compute mahalanobis distance
    c1 = reshape(cell2mat(proposedCenters), 3, []).';
    n = size(c1, 1);
    c1 = blockRepeatMatrix(numel(predictedCenters), c1);
    c2 = blkdiag(predictedCenters{:})';
    c2 = repelem(c2, n, 1);
    cov = blkdiag(predictedCov{:});
    d = mahalDistance(c1, c2, cov);
    d = reshape(d, n, []);
    n = max(size(d, 1), size(d, 2));
    dSquare = Inf(n);
    dSquare(1 : size(d, 1), 1 : size(d, 2)) = d;
    d = dSquare;
    
    % Total dist
    idx = perms(1 : n);
    idx = reshape(idx', [], 1);
    r = repmat(1 : n, 1, factorial(n))';
    d = d(sub2ind(size(d), r, idx));
    d = reshape(d, n, [])';
    d(d >= Inf) = 0; % Don't include inf for summation
    d = sum(d, 2);
    [~, matchIdx] = min(d);
    
    % Gather
    idx1 = reshape(r, n, [])'; % Measured
    idx2 = reshape(idx, n, [])'; % Predicted
    idx1 = idx1(matchIdx, :);
    idx2 = idx2(matchIdx, :);
    matchedCenters = [idx1' , idx2'];
    d = dSquare(sub2ind(size(dSquare), idx1, idx2));
    
    % Obtain this value from a chi-square dist with 3 DoF
    distThresh = chi2inv(pThresh, 3);
    matchedCenters = matchedCenters(d < distThresh, :);   
end

