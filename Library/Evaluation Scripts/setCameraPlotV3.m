function markerHandles = setCameraPlotV3(markerDict)
%SETCAMERAPLOT Summary of this function goes here
%   Detailed explanation goes here

    figure;
    axisLimit = 1;
    %axis(axes, [-axisLimit, axisLimit, -axisLimit, axisLimit, -axisLimit, axisLimit]);
    axis(axes, [-0.6, 0.6, -0.6, 0.6, -0.1, 1.1]);
    xlabel('x [m]');
    ylabel('y [m]');
    zlabel('z [m]');
    %view(0, 0); % Disable!
    grid on;
    hold on;
    
    % markers
    cameraSize = 0.05;
    markerHandles = {};
    for i = markerDict
        marker.plot = plotCamera('Size', cameraSize, 'Location', [0, 0, 0], ...
        'Orientation', eye(3), 'Color', 'w', 'Opacity', 0., 'AxesVisible', true);
        marker.text = text(0 + 0.01,0 + 0.01,0  + 0.01, sprintf('id: %i', i));
        markerHandles{end + 1} = marker;
    end
    
    hold off;
    
end

