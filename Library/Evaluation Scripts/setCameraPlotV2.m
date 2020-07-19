function [cameraHandles, markerHandles] = setCameraPlotV2(cameraDict, markerDict)
%SETCAMERAPLOT Summary of this function goes here
%   Detailed explanation goes here

    figure;
    axisLimit = 1;
    %axis(axes, [-axisLimit, axisLimit, -axisLimit, axisLimit, -axisLimit, axisLimit]);
    axis(axes, [-1, 1, -1, 1, -1, 1]);
    xlabel('x [m]');
    ylabel('y [m]');
    zlabel('z [m]');
    %view(0, 0); % Disable!
    grid on;
    hold on;

    % cam
    cameraSize = 0.05;
    cameraHandles = {};
    for i = cameraDict
        %cam.plot = plotCamera('Size', cameraSize, 'Location', [0, 0, 0], 'Orientation', eye(3), 'Color', 'r', 'Opacity', 0.);
        
        if i == 1
        
            cam.plot = plotCamera('Size', cameraSize, 'Location', [0, 0, 0], 'Orientation', eye(3), 'Color', 'g', 'Opacity', 0., 'AxesVisible', true);
            
        else
            
            cam.plot = plotCamera('Size', cameraSize, 'Location', [0, 0, 0], 'Orientation', eye(3), 'Color', 'r', 'Opacity', 0., 'AxesVisible', true);
            
        end
        %cam.text = text(0 + 0.01,0 + 0.01,0  + 0.01, sprintf('id: %i', i));
        cameraHandles{end + 1} = cam;
    end
    
    % markers
    markerHandles = {};
    for i = markerDict
        marker.plot = plotCamera('Size', cameraSize, 'Location', [0, 0, 0], ...
        'Orientation', eye(3), 'Color', 'w', 'Opacity', 0., 'AxesVisible', true);
        marker.text = text(0 + 0.01,0 + 0.01,0  + 0.01, sprintf('id: %i', i));
        markerHandles{end + 1} = marker;
    end
    
    hold off;
    
end

