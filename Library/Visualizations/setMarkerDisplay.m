function frameHandles = setMarkerDisplay(resolution, cameraDict)
%SETMARKERDISPLAY Setup a display that show the detected markers.
% inputs:
%   resolution          Image resolution.
%   cameraDict          Array of camera IDs.
% outputs:
%   frameHandles        Handle, pass to the corresponding update
%                       function.

    %% Set the marker display
    figure;
    frameHandles = {};
    nScreens = numel(cameraDict);
    for i = 1 : nScreens
        subplot(1, nScreens, i);
        fh = imshow(zeros([resolution, 3]));
        hold on;
        frameHandles{end+1} = fh;
        text(0, resolution(1) + 50, sprintf('id: %i', cameraDict(i)), 'FontSize', 12, 'Color', 'red')
        hold off;
    end
end