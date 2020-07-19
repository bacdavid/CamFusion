function [features, points, misc] = detectFeaturesROI(frame, rois, cameraParameters, surfThreshold, nOctaves)
%DETECTFEATURESROI Detect features within ROI.
% inputs:
%   frame               Target frame.
%   rois                Cell of ROIs.
%   cameraParameters    Camera parameters of the recording camera.
%   surfThreshold       Feature quality threshold.
%   nOctaves            Number of octaves to scan.
% ouputs:
%   features            Features.
%   points              2d points corresponding to the features.
%   (misc)              Undistorted grayscale frame.

    %% Detect features in ROI
    r = cat(1, rois{:});
    intersectionArea = rectint(r, r);
    intersectionArea = intersectionArea - diag(diag(intersectionArea)); % Get rid of self intersections
    maxArea = max(intersectionArea, [], 'all');
    ratio = maxArea / prod(cameraParameters.ImageSize);
    if ratio > 0.3
        [features, points, frame] = detectFeatures(frame, cameraParameters, surfThreshold, nOctaves);
    else
        frame = undistortImage(rgb2gray(frame), cameraParameters);
        points = [];
        features = [];
        for i = 1 : numel(rois)
            p = detectSURFFeatures(frame, 'ROI', rois{i}, 'MetricThreshold', surfThreshold, 'NumOctaves', nOctaves);
            [f, p] = extractFeatures(frame, p);
            if isempty(points) % Annoying way to append, but MATLAB doesn't allow other
                points = p;
            else
                points = [points; p];
            end
            features = [features; f];
        end
        [~, idx, ~] = unique(points.Location, 'rows'); %%ADD EXCEPTION IF NO FEATURES DETECTED!!
        points = points(idx);
        features = features(idx, :);
    end  
    
    if nargout > 2
        misc.frame = frame;
    end
end