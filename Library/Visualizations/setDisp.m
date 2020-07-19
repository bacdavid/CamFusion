function frameHandles = setDisp(resolution, cameraDict)
%SETDISP Setup a display.
% inputs:
%   resolution          Image resolution.
%   cameraDict          Array of camera IDs.
% outputs:
%   frameHandles        Handle, pass to the corresponding update
%                       function.

    %% Set the display
    figure;
    frameHandles = {};
    nScreens = numel(cameraDict);
    for i = 1 : nScreens
        subplot(1, nScreens, i);
        fh = imshow(zeros([resolution, 3]));
        frameHandles{end+1} = fh;
        hold on;
        text(0, resolution(1) + 50, sprintf('id: %i', cameraDict(i)), 'FontSize', 12, 'Color', 'red')
        hold off;
    end
end