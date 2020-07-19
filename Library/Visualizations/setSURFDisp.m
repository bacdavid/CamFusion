function axHandles = setSURFDisp(resolution, cameraDict)
%SETSURFDISP  Setup a display that shows SURF features in a frame.
% inputs:
%   resolution          Image resolution.
%   cameraDict          Array of camera IDs.
% outputs:
%   axHandles           Axes handle, pass to the corresponding update
%                       function.

    %% Set the SURF display
    figure;
    axHandles = {};
    nScreens = numel(cameraDict);
    for i = 1 : nScreens
        ax = subplot(1, nScreens, i);
        imshow(zeros(resolution), 'Parent', ax); % Grayscale
        hold on;
        plot(SURFPoints([1, 1]), ax);
        axHandles{end+1} = ax;
        hold off;
    end
end