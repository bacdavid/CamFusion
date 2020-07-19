function distortionCoefficients = getDistortionCoefficients(cameraParameters)
%GETDISTORTIONPARAMS Helper function to extract distortion coefficients
%from camera parameters. The order is as such that it is compatible with
%openCV.
% inputs:
%   cameraParameters        Camera parameters.
% outputs:
%   distortionCoefficients  Distortion coefficients.
    
    %% Get the distortion coefficients
    distortionCoefficients = [cameraParameters.RadialDistortion(1), cameraParameters.RadialDistortion(2), ...
    cameraParameters.TangentialDistortion(1), cameraParameters.TangentialDistortion(2), ...
    cameraParameters.RadialDistortion(3)];
end