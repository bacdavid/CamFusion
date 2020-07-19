function axHandles = updateSURFDisp(frames, points, axHandles)
%UPDATESURFDISP Display the SURF display.
% inputs:
%   frames            	Cell of frames.
%   points              Cell of SURF point arrays.
%   axHandles           Cell of axes.
% outputs:
%   axHandles           Return of the axHandle, not really used.

    %% Updat SURF display
    for i = 1 : numel(frames)
        ax = axHandles{i};
        imshow(frames{i}, 'Parent', ax)
        hold on;
        p = points{i};
        if isempty(p); p = SURFPoints([1, 1]); end
        plot(p, ax);
        hold off;
    end
end