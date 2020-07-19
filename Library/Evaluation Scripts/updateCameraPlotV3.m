function markerHandles = updateCameraPlotV3(yMarker, markerHandles)
%UPDATEFUSIONPLOT Summary of this function goes here
%   Detailed explanation goes here


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

