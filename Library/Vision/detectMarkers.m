function [markers, markerIds, misc] = detectMarkers(frame, markerSize, markerDict, cameraParameters)
%DETECTMARKERS Detect markers in a frame.
% inputs:
%   frame               Target frame.
%   markerSize          Size of the marker in meters.
%   markerDict          Array of valid marker IDs.
%   cameraParameters    Camera parameters of the recording camera.
% ouputs:
%   markers             Markers.
%   markerIds           IDs corresponding to each marker.
%   (misc)              Misc out containing a bunch of stuff for plotting,
%                       used by DRAWMARKERONFRAME.

    %% Detect markers
    % Estimate pose
    [corners, ids, ~] = cv.detectMarkers(frame, {'Predefined', 'ArucoOriginal'});
    idx = ismember(ids, markerDict);
    corners = corners(idx);
    markerIds = ids(idx);
    [rvecs, tvecs] = cv.estimatePoseSingleMarkers(corners, markerSize, getCameraMatrix(cameraParameters), getDistortionCoefficients(cameraParameters));
    
    % Bring to format and wrap to pi
    t = cat(1, tvecs{:});
    r = cat(1, rvecs{:});
    x = vecnorm(r, 2, 2);
    x(x < 1e-5) = 1; % Avoid any div-zero errors
    r = r ./ x .* wrapToPi(x);
    s = [t, r];
    markers = num2cell(s', 1)';
    
    % Misc
    if nargout > 1
        % Inputs
        misc.frame = frame;
        misc.markerSize = markerSize;
        misc.markerDict = markerDict;
        misc.cameraParameters = cameraParameters;
        % Outputs
        misc.markers = markers;
        misc.markerIds = markerIds;
        misc.corners = corners;
        % Additional
        misc.tvecs = tvecs;
        misc.rvecs = rvecs;
    end
end