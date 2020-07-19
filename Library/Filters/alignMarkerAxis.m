function alignedMarkers = alignMarkerAxis(proposedMarkers, predictedMarkers)
%ALIGNMARKERAXIS Align the angle axis of the measured marker with that of a
%predicted marker. An angle axis has two representation; One is 'regular'
%and the other is the flipped version of it with corresponding angle.
%Inputs can either be arrays or cells of arrays.
% inputs:
%   proposedMarkers     Marker obtained by measurement.
%   predictedMarkers    Markers that were predicted by a kalman filter.
% outputs:
%   alignedMarkers      Proposed markers but with newly adjusted angle axis.

    %% Adjust axis
    if ~isempty(proposedMarkers)
        s1 = cat(2, proposedMarkers{:})';
        phi1 = s1(:, 4:end);
        s2 = cat(2, predictedMarkers{:})';
        phi2 = s2(:, 4:end);
        phi1 = alignAngleAxis(phi1, phi2);
        proposedMarkers = [s1(:, 1:3), phi1];
        alignedMarkers = num2cell(proposedMarkers', 1)';
    else
        alignedMarkers = proposedMarkers;
    end  
end