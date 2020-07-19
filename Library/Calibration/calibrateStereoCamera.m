function [stereoParams, estimationErrors] = calibrateStereoCamera(squareSize, imageSet1, imageSet2)
%CALIBRATESTEREOCAMERA Calibrate stereo cameras.
% inputs:
%   squareSize          Size of each checkerboard square in meters.
%   imageSet1           Images coming from camera 1 as an "imageSet".
%   imageSet2           Images coming from camera 2 as an "imageSet"
% outputs:
%   stereoParameters    Stereo parameters.
%   estimationErrors    Estimation errors from the calibration.
    
    %% Calibrate a stereo pair of cameras

    I1 = {};
    I2 = {};
    for i = 1 : imageSet1.Count
        img1 = read(imageSet1, i);
        img2 = read(imageSet2, i);
        I1{end+1} = img1;
        I2{end+1} = img2;
    end
    images1 = cat(4, I1{:});
    images2 = cat(4, I2{:});

    [imagePoints, boardSize] = detectCheckerboardPoints(images1, images2);
    worldPoints = generateCheckerboardPoints(boardSize, squareSize);
    imageSize = [size(img1, 1), size(img1, 2)];
    [stereoParams, estimationErrors] = estimateCameraParameters(imagePoints, worldPoints, ...
        'ImageSize', imageSize, 'WorldUnits', 'm', ...
        'NumRadialDistortionCoefficients', 3, ...
        'EstimateTangentialDistortion', true);
end