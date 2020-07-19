function [frameHandles, centerHandles, roiHandles] = updateCenterDisplayROI(frames, centers, rois, frameHandles, centerHandles, roiHandles)
%UPDATECENTERDISPLAYROI Update a display that contains centers of objects
%and also the predicted ROIs.
% inputs:
%   frames              Cell of frames.
%   centers             Cell of 2 dimensional centers.
%   rois                Cell of rois.
%   frameHandles        Frame handle from the corresponding setup function.
%   centerHandles       Center handle from the corresponding setup function.
%   roiHandles          ROI handle from the corresponding setup function.
% outputs:
%   frameHandle         Return of the cameraHandles, not really used.
%   centerHandles       Return of the centerHandles, not really used.
%   roiHandles          Return of the centerHandles, not really used.

    %% Update display with centers and ROIs
    if iscell(frames)

        for i = 1 : numel(frames)
            fh = frameHandles{i};
            fh.CData = frames{i};
            ph = centerHandles{i};
            c = centers{i};
            if isempty(c); c = [1, 1]; end
            ph.XData = c(:, 1);
            ph.YData = c(:, 2); 
            rh = roiHandles{i};
            r = rois{i};
            if isempty(r); r = [1, 1, 0, 0]; end
            [x, y] = rois2Patches(r);
            rh.XData = x;
            rh.YData = y;
        end

    else

        frameHandles.CData = frames;
        if isempty(centers); centers = [1, 1]; end
        centerHandles.XData = centers(:, 1);
        centerHandles.YData = centers(:, 2);
        if isempty(rois); rois = [1, 1, 0, 0]; end
        [x, y] = rois2Patches(rois);
        roiHandles.XData = x;
        roiHandles.YData = y;

    end
end