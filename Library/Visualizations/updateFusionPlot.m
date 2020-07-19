function [cameraHandles, markerHandles, objectHandles] = updateFusionPlot(yCamera, yMarker, yObject, cameraHandles, markerHandles, objectHandles)
%UPDATEFUSIONPLOT Update the fusion plot.
% inputs:
%   yCamera             States of the cameras as cell of arrays.
%   yMarker             States of the markers as cells of arrays.
%   yObject             State of the objects as cells of arrays.
%   cameraHandles       Cam handle from the corresponding setup function.
%   markerHandles       Marker handle from the corresponding setup function.
%   objectHandles       Object handle from the corresponding setup function.
% outputs:
%   cameraHandles       Return of the cameraHandles, not really used.
%   markerHandles       Return of the cameraHandles, not really used.
%   objectHandles       Return of the cameraHandles, not really used.

    %% Update fusion plot
    % Cam
    yCamera = cat(2, yCamera{:});
    for i = 1 : size(yCamera, 2)
        cam = cameraHandles{i};
        camPlot = cam.plot;
        camText = cam.text;
        camPlot.Location = yCamera(1 : 3, i);
        camPlot.Orientation = cv.Rodrigues(yCamera(4 : 6, i))'; % MATLAB standard
        camText.Position = yCamera(1 : 3, i) + 0.01;
    end

    % Markers
    yMarker = cat(2, yMarker{:});
    for i = 1 : size(yMarker, 2)
        marker = markerHandles{i};
        markerPlot = marker.plot;
        markerText = marker.text;
        markerPlot.Location = yMarker(1 : 3, i);
        markerPlot.Orientation = cv.Rodrigues(yMarker(4 : 6, i))';
        markerText.Position = yMarker(1 : 3, i) + 0.01;
    end
    
    % Objects
    yObject = cat(2, yObject{:});
    for i = 1 : size(yObject, 2)
        object = objectHandles{i};
        objectPlot = object.plot;
        objectText = object.text;
        objectPlot.XData = yObject(1, :);
        objectPlot.YData = yObject(2, :);
        objectPlot.ZData = yObject(3, :);
        objectText.Position = yObject(1 : 3, i) + 0.01;
    end
end