function [cameraHandles, markerHandles] = setCameraPlot(cameraDict, markerDict)
%SETCAMERAPLOT Setup a plot that show cameras and markers.
% inputs:
%   cameraDict          Array of camera IDs.
%   markerDict          Array of marker IDs.
% outputs:
%   cameraHandles       Handle, pass to the corresponding update
%                       function.
%   markerHandles       Handle, pass to the corresponding update
%                       function.

    %% Set the camera plot
    figure;
    axisLimit = 1;
    axis(axes, [-axisLimit, axisLimit, -axisLimit, axisLimit, -axisLimit, axisLimit]);
    xlabel('x [m]');
    ylabel('y [m]');
    zlabel('z [m]');
    %view(0, 0); % Disable!
    grid on;
    hold on;

    % Cam
    cameraSize = 0.05;
    cameraHandles = {};
    for i = cameraDict
        cam.plot = plotCamera('Size', cameraSize, 'Location', [0, 0, 0], 'Orientation', eye(3), 'Color', 'r', 'Opacity', 0.);
        cam.text = text(0 + 0.01,0 + 0.01,0  + 0.01, sprintf('id: %i', i));
        cameraHandles{end + 1} = cam;
    end
    
    % Markers
    markerHandles = {};
    for i = markerDict
        marker.plot = plotCamera('Size', cameraSize, 'Location', [0, 0, 0], ...
        'Orientation', eye(3), 'Color', 'w', 'Opacity', 0., 'AxesVisible', true);
        marker.text = text(0 + 0.01,0 + 0.01,0  + 0.01, sprintf('id: %i', i));
        markerHandles{end + 1} = marker;
    end
    
    hold off;
end