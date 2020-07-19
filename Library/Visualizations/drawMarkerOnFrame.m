function frame = drawMarkerOnFrame(frame, corners, ids, rvecs, tvecs, camMatrix, distCoeff)
%DRAWMARKERSONFRAME Helper function that draws a marker on the frame.
% inputs:
%   frame               Single frame.
%   corners             Corners as provided by corresponding ARUCO
%                       function.
%   ids                 IDs as provided by corresponding ARUCO
%                       function.
%   rvecs               Rotation vectors as provided by corresponding ARUCO
%                       function.
%   tvecs               Translation vectors as provided by corresponding
%                       ARUCO function.
%   camMatrix           Camera matrix as provided by GETCAMERAMATRIX.
%   distCoeff           Distortion coefficients as provided by
%                       GETDISTORTIONCOEFFICIENTS.
% outputs:
%   frame               Frame containing the highlighted marker.

    %% Draw marker on frame
    frame = cv.drawDetectedMarkers(frame, corners, 'IDs', ids);
    for i=1:numel(ids)
        frame = cv.drawAxis(frame, camMatrix, distCoeff, rvecs{i}, tvecs{i}, 0.05);
    end
end