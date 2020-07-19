function [tform, validMatches] = estimateTransform(validPoints, refPoints)
%ESTIMATETRANSFORM Estimate a mapping from reference points, ie. points
%stored in a dictionary, to valid points, ie. points in a current frame.
% inputs:
%   validPoints         Target points.
%   refPoints           Source points.
% ouputs:
%   tform               transform.
%   validMatches        The matches that were used to compute tform.

    %% Estimate transform
    [tform, refPointsUsed, validPointsUsed] = estimateGeometricTransform(refPoints, validPoints, 'projective', 'MaxNumTrials', 200, 'Confidence', 99.99, 'MaxDistance', 2);
    used1Idx = ismember(validPoints.Location, validPointsUsed.Location, 'rows');
    used2Idx = ismember(refPoints.Location, refPointsUsed.Location, 'rows');
    validMatches = used1Idx & used2Idx;
end