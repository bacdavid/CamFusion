function frameHandles = updateDisp(frames, frameHandles)
%UPDATEDISP Update the a display.
% inputs:
%   frames              Cell of frames.
%   frameHandles        Frame handle from the corresponding setup function.
% outputs:
%   frameHandle         Return of the cameraHandles, not really used.

    %% Update fusion plot
    for i = 1 : numel(frames)
        fh = frameHandles{i};
        fh.CData = frames{i};
    end
end