function frameHandles = updateMarkerDisplay(misc_detectMarkers, frameHandles)
%UPDATEMARKERDISPLAY Update the marker display. By setting an entry in the
%cell array to "[]" it is skipped and the hold frame is kept.
% inputs:
%   misc_detectMarkers  Misc output from detect marker function.
%   frameHandles        Frame handles from the corresponding setup function.
% outputs:
%   frameHandles       	Return of the frameHandles, not really used.

    %% Update marker display
    if iscell(misc_detectMarkers)

        for i = 1 : numel(misc_detectMarkers)
            fh = frameHandles{i};
            dm = misc_detectMarkers{i};
            if isempty(dm); continue; end
            cameraParameters = dm.cameraParameters;   
            frame = drawMarkerOnFrame(dm.frame, dm.corners, dm.markerIds, dm.rvecs, dm.tvecs, getCameraMatrix(cameraParameters), getDistortionCoefficients(cameraParameters));
            fh.CData = frame;
        end

    else

        cameraParameters = misc_detectMarkers.cameraParameters;   
        frame = drawMarkerOnFrame(misc_detectMarkers.frame, misc_detectMarkers.corners, misc_detectMarkers.markerIds, misc_detectMarkers.rvecs, misc_detectMarkers.tvecs, getCameraMatrix(cameraParameters), getDistortionCoefficients(cameraParameters));
        frameHandles.CData = frame;

    end

end