function matchedMarkers = matchMarkers(proposedMarkers, predictedMarkers, predictedCov, pThresh)
%MATCHMARKERS Eliminate outliers via Mahalanobis distance.
% inputs:
%   proposedMarkers     Proposed markers.
%   predictedMarkers    Predicted markers.
%   predictedCov        Covariance to use for Mahalanobis distance.
%   pThresh             Threshold for outliers.
% outputs:
%   matchedmarkers      Index pairs, where the first index corresponds to
%                       the proposed markers and second to the predicted.

    %% Match markers
    % If no markers have been measured
    if isempty(proposedMarkers)
        matchedMarkers = double.empty(0, 2);
        return;
    end
     
    % Compute dist
    m1 = blkdiag(proposedMarkers{:})';
    m2 = blkdiag(predictedMarkers{:})';
    cov = blkdiag(predictedCov{:});
    d = mahalDistance(m1, m2, cov);
    
    % Obtain this value from a chi-square dist with 6 DoF
    distThresh = chi2inv(pThresh, 6);
    matchedMarkers = 1 : numel(proposedMarkers);
    matchedMarkers = repmat(matchedMarkers', 1, 2);
    matchedMarkers = matchedMarkers(d < distThresh, :);
end