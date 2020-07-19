function [stateIds, stateIdsFixed] = associateMarkers(markerIds, markerDict, stateDict)
%ASSOCIATEMARKERS Associate marker Ids to the corresponding entry in the
%state.
% inputs:
%   markerIds           Array of detected marker Ids.
%   markerDict          Array of valid marker Ids.
%   stateDict           Array of state ids for the markers in markerDict
% outputs:
%   stateIds            Array of state Ids that correspond to the detected
%                       marker Id.
%   stateIdsFixed       Same array as stateIds except that the origin is
%                       zero'd.
    [~, idx] = ismember(markerIds, markerDict);
    stateIds = stateDict(idx);
    stateIdsFixed = stateIds;
    stateIdsFixed(markerDict(idx) == markerDict(1)) = 0; % Origin is zero'd for fixing
end