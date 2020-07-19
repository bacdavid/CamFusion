function [cameraParams, estimationErrors] = calibrateSingleCamera(squareSize, imageSet)
%CALIBRATESINGLECAMERA Calibrate camera.
% inputs:
%   squareSize          Size of each checkerboard square in meters.
%   imageSet            Images coming from the camera as an "imageSet".
% outputs:
%   cameraParameters    Camera parameters.
%   estimationErrors    Estimation errors from the calibration.
    
    %% Calibrate a camera
    I = {};
    for i = 1 : imageSet.Count
        img = read(imageSet, i);
        I{end+1} = img;
    end
    images = cat(4, I{:});

    [imagePoints, boardSize] = detectCheckerboardPoints(images);
    worldPoints = generateCheckerboardPoints(boardSize, squareSize);
    imageSize = [size(img, 1), size(img, 2)];
    [cameraParams, estimationErrors] = estimateCameraParameters(imagePoints, worldPoints, ...
        'ImageSize', imageSize, 'WorldUnits', 'm', ...
        'NumRadialDistortionCoefficients', 3, ...
        'EstimateTangentialDistortion', true);
end