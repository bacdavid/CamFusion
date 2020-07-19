function [features, points, misc] = detectStrongestFeatures(nFeatures, frame, cameraParameters, surfThreshold, nOctaves)
%DETECTSTRONGESTFEATURES Detect the n strongest features features in a
%frame.
% inputs:
%   nFeatures           Number of features to select.
%   frame               Target frame.
%   cameraParameters    Parameters of the recording camera.
%   surfThreshold       Feature quality threshold, only has to be lowered
%                       if frame does not provide n features. 
%   nOctaves            Number of octaves to scan.
% ouputs:
%   features            Features.
%   points              2d points corresponding to the features.
%   (misc)              Undistorted grayscale frame.

    %% Detect the strongest features
    frame = undistortImage(rgb2gray(frame), cameraParameters);
    points = detectSURFFeatures(frame, 'MetricThreshold', surfThreshold, 'NumOctaves', nOctaves);
    points = points.selectStrongest(nFeatures);
    [features, points] = extractFeatures(frame, points);
    
    if nargout > 2
        misc.frame = frame;
    end
end