function [validPoints, refPoints] = associatePoints(points, refId, matchIdx, matchIds, objectDict)
%ASSOCIATEPOINTS Associate points from a current frame to points in the
%dictionary. Please refer to MATCHDICTIONARY for more info.
% inputs:
%   points              Points in the current frame.
%   refId               The ID of the target frame in the dictionary.
%   matchIdx            Matches between the points in the current frame and
%                       the frame in the dictionary at "refId".
%   matchIds            Image ID per match in "matchIdx".
%   objectDict          Object dictionary where the "refPoints" are
%                       extracted from.
% ouputs:
%   validPoints         Points in the current frame that are associated
%                       with the points in the dictionary at "refId".
%   refPoints           Corresponding points in the dictionary, they match
%                       "validPoints".
    
    %% Associate points 
    dictPoints = vertcat(objectDict.Points{:});
    targetMatches = matchIdx((matchIds == refId), :);
    refPoints = dictPoints(targetMatches(:, 2));
    validPoints = points(targetMatches(:, 1));   
end