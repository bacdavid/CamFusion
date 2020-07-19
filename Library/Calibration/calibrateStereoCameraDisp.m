function [stereoParameters, estimationErrors] = calibrateStereoCameraDisp(squareSize, imageSet1, imageSet2)
%CALIBRATESTEREOCAMERA Calibrate stereo cameras with a display.
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

    [imagePoints, boardSize, validIdx] = detectCheckerboardPoints(images1, images2);
    worldPoints = generateCheckerboardPoints(boardSize, squareSize);
    imageSize = [size(img1, 1), size(img1, 2)];
    [stereoParameters, estimationErrors] = estimateCameraParameters(imagePoints, worldPoints, ...
        'ImageSize', imageSize, 'WorldUnits', 'm', ...
        'NumRadialDistortionCoefficients', 3, ...
        'EstimateTangentialDistortion', true);
    
    validImages1 = images1(:, :, :, validIdx);
    validImages2 = images2(:, :, :, validIdx);
    
    fig = figure;
    
    for i = 1 : size(validImages1, 4)
        
        subplot(1, 2, 1);
        imshow(validImages1(:, :, :, i));
        hold on;
        plot(imagePoints(:, 1, i, 1), imagePoints(:, 2, i, 1));
        hold off;
        
        subplot(1, 2, 2);
        imshow(validImages2(:, :, :, i));
        hold on;
        plot(imagePoints(:, 1, i, 2), imagePoints(:, 2, i, 2));
        hold off;
        
        pause(0.2); % display with 0.2 sec break
        
    end
    
    close(fig);
end