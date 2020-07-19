function cameraMatrix = getCameraMatrix(cameraParameters)
%GETCAMERAMATRIX Helper to extrac camera matrix from camera parameters. The
%output is compatible with openCV.
% inputs:
%   cameraParameters    Camera parameters.
% outputs:
%   cameraMatrix        Camera matrix.
    
    %% get the camera matrix
    cameraMatrix = cameraParameters.IntrinsicMatrix';
end