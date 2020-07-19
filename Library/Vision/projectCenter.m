function center = projectCenter(refId, tform, objectDict)
%PROJECTCENTER Project a point via its tform.
% inputs:
%   refId               Image ID in the dictionary, used to compute the
%                       center of the features.
%   tform               Transformation.
%   objectDict          Object dictionary.
% ouputs:
%   center              Forward transformed point.

    %% Triangulate centers
    dictCenter = mean(objectDict.Points{refId}.Location);
    center = transformPointsForward(tform, dictCenter);
end