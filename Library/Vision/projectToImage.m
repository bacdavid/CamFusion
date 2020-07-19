function imgPoints = projectToImage(worldPoints, cameraParameters)
%PROJECTTOIMAGE Project 3d world points to the image.
% inputs:
%   worldPoints         3d world points.
%   cameraParameters    Camera parameters of camera to project on.    
% ouputs:
%   imgPoints           2d coordinates of world points.

    %% Project points
    fu = cameraParameters.FocalLength(1);
    fv = cameraParameters.FocalLength(2);
    u0 = cameraParameters.PrincipalPoint(1);
    v0 = cameraParameters.PrincipalPoint(2);
    u = fu * worldPoints(:, 1) ./ worldPoints(:, 3) + u0;
    v = fv * worldPoints(:, 2) ./ worldPoints(:, 3) + v0;
    imgPoints = [u, v];
end