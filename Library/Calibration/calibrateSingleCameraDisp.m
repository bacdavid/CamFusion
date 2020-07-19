function [cameraParameters, estimationErrors] = calibrateSingleCameraDisp(squareSize, imageSet)
%CALIBRATESINGLECAMERADISP Calibrate camera with a display.
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

    [imagePoints, boardSize, validIdx] = detectCheckerboardPoints(images);
    worldPoints = generateCheckerboardPoints(boardSize, squareSize);
    imageSize = [size(img, 1), size(img, 2)];
    [cameraParameters, estimationErrors] = estimateCameraParameters(imagePoints, worldPoints, ...
        'ImageSize', imageSize, 'WorldUnits', 'm', ...
        'NumRadialDistortionCoefficients', 3, ...
        'EstimateTangentialDistortion', true);
    
    validImages = images(:, :, :, validIdx);
    
    fig = figure;
    
    for i = 1 : size(validImages, 4)
        
        imshow(validImages(:, :, :, i));
        hold on;
        plot(imagePoints(:, 1, i), imagePoints(:, 2, i));
        hold off;
        
        pause(0.2); % display with 0.2 sec break
        
    end
        
    close(fig); 
end