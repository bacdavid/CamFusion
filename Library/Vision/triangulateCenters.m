function worldCenters = triangulateCenters(yCamera1, yCamera2, centers1, centers2, cameraParameters1, cameraParameters2)
%TRIANGULATECENTERS Triangulate 2 dimensional points from 2 images to
%obtain a point in 3 dimensional space.
% inputs:
%   yCamera1            State of camera 1.
%   yCamera2            State of camera 2.
%   centers1            2d coordinates of target point in camera 1.
%   centers2            2d coordinates of target point in camera 2.
%   cameraParameters1   Camera parameters of camera 1.
%   cameraParameters2   Camera parameters of camera 2.
% ouputs:
%   worldCenters        Centers expressed in 3d world coordinates.

    %% Triangulate centers
    if isempty(centers1)
        worldCenters = {[]};
        return;
    end
    
    R1 = cv.Rodrigues(yCamera1(4:6));
    R2 = cv.Rodrigues(yCamera2(4:6));
    t1 = yCamera1(1:3);
    t2 = yCamera2(1:3);
    
    % Relative pose
    Rrelative = R1' * R2;
    trelative = R1' * (t2 - t1);
    textr = -trelative' * Rrelative;
    
    camMatrix1 = cameraMatrix(cameraParameters1, eye(3), zeros(3, 1));
    camMatrix2 = cameraMatrix(cameraParameters2, Rrelative, textr);

    worldCenters = triangulate(centers1, centers2, camMatrix1, camMatrix2);
    worldCenters = num2cell(worldCenters', 1)';
end