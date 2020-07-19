function [cameraHandles, markerHandles] = updateCameraPlotV2(yCamera, yMarker, cameraHandles, markerHandles)
%UPDATEFUSIONPLOT Summary of this function goes here
%   Detailed explanation goes here

    % cam
    yCamera = cat(2, yCamera{:});
    for i = 1 : size(yCamera, 2)
        cam = cameraHandles{i};
        camPlot = cam.plot;
        %camText = cam.text;
        camPlot.Location = yCamera(1 : 3, i);
        camPlot.Orientation = cv.Rodrigues(yCamera(4 : 6, i))'; % MATLAB standard
        %camText.Position = yCamera(1 : 3, i) + 0.01;
    end

    % markers
    yMarker = cat(2, yMarker{:});
    for i = 1 : size(yMarker, 2)
        marker = markerHandles{i};
        markerPlot = marker.plot;
        markerText = marker.text;
        markerPlot.Location = yMarker(1 : 3, i);
        markerPlot.Orientation = cv.Rodrigues(yMarker(4 : 6, i))';
        markerText.Position = yMarker(1 : 3, i) + 0.01;
    end

end

