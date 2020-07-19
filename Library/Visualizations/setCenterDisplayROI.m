function [frameHandles, centerHandles, roiHandles] = setCenterDisplayROI(resolution, cameraDict)
%SETCENTERDISPLAYROI Setup a display that displays centers of objects along
%with the predicted ROIs.
% inputs:
%   resolution          Image resolution.
%   cameraDict          Array of camera IDs.
% outputs:
%   frameHandles        Handle, pass to the corresponding update
%                       function.
%   centerHandles       Handle, pass to the corresponding update
%                       function.
%   roiHandles          Handle, pass to the corresponding update
%                       function.

    %% Set the display for objects and ROIs
    figure;
    frameHandles = {};
    centerHandles = {};
    roiHandles = {};
    nScreens = numel(cameraDict);
    for i = 1 : nScreens
        subplot(1, nScreens, i);
        fh = imshow(zeros([resolution, 3]));
        frameHandles{end+1} = fh;
        hold on;
        ph = plot(1, 1, 'r+', 'MarkerSize', 100, 'LineWidth', 2);
        centerHandles{end+1} = ph;
        rh = patch('XData', 0, 'YData', 0, 'FaceColor', 'none');
        roiHandles{end+1} = rh;
        text(0, resolution(1) + 50, sprintf('id: %i', cameraDict(i)), 'FontSize', 12, 'Color', 'red')
        hold off;
    end
end