function rois = predictROI(hObject, SObject, cameraParameters, minSize)
%PREDICTROI Predict the ROI via a 3d estimate of the objects position.
%Inputs, but "cameraParameters" and "minSize", can either be arrays or
%cells of arrays.
% inputs:
%   hObject             Measurement estimate of the 3d position.
%   SObject             Associated uncertainty as covariance matrix.
%   cameraParameters    Camera parameters used for projection.
%   minSize             Minimum object size in meters.
% ouputs:
%   rois                Cell or array of ROIs.

    %% Predict ROIs
     if iscell(hObject)
        
        rois = cell(numel(hObject), 1);
        for i = 1 : numel(hObject)
            rois{i} = predictROI(hObject{i}, SObject{i}, cameraParameters, minSize);
        end
        
     else

        factor = 0.1; % Any factor to go with covariance factor
        maxEig = max(eig(SObject)); % Max "uncertainty axis"
        side = max(factor * sqrt(maxEig), minSize);

        s = [side, 0, hObject(3)];
        sNew = projectToImage(s, cameraParameters);
        sNew = sNew(1) - cameraParameters.PrincipalPoint(1); % Substract the offset since relative
        sNew = abs(sNew);
        boxCenter = projectToImage(hObject', cameraParameters);
        x = min(max(boxCenter(1) - sNew / 2, 1), cameraParameters.ImageSize(2));
        y = min(max(boxCenter(2) - sNew / 2, 1), cameraParameters.ImageSize(1));
        w = min(sNew, cameraParameters.ImageSize(2) - x);
        h = min(sNew, cameraParameters.ImageSize(1) - y);

        rois = [x, y, w, h];
        
     end
end