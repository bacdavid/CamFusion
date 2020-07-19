function [features, points, misc] = detectFeatures(frame, cameraParameters, surfThreshold, nOctaves)
%DETECTFEATURES Detect features.
% inputs:
%   frame               Target frame.
%   cameraParameters    Camera parameters of the recording camera.
%   surfThreshold       Feature quality threshold.
%   nOctaves            Number of octaves to scan.
% ouputs:
%   features            Features.
%   points              2d points corresponding to the features.
%   (misc)              Undistorted grayscale frame.

    %% Detect features in frame
    frame = undistortImage(rgb2gray(frame), cameraParameters);
    points = detectSURFFeatures(frame, 'MetricThreshold', surfThreshold, 'NumOctaves', nOctaves);
    [features, points] = extractFeatures(frame, points);
    
    if nargout > 2
        misc.frame = frame;
    end
end