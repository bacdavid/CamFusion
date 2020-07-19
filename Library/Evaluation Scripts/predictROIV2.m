function rois = predictROIV2(hObject, cameraParameters, minSize)
%PREDICTROI Predict a set of rois based on the measurement prediction.
% inputs:
%   hObject: 3 x 1 array or cell containing such arrays
%   SObject: 3 x 3 array or cell containing such arrays
%   cameraFile: Single camera file corresponding to the "measuring" camera

     if iscell(hObject)
        
        rois = cell(numel(hObject), 1);
        for i = 1 : numel(hObject)
            rois{i} = predictROIV2(hObject{i}, cameraParameters, minSize);
        end
        
     else
        side = minSize;

        s = [side, 0, hObject(3)];
        sNew = projectToImage(s, cameraParameters);
        sNew = sNew(1) - cameraParameters.PrincipalPoint(1); % substract the offset since relative
        sNew = abs(sNew);
        boxCenter = projectToImage(hObject', cameraParameters);
        x = min(max(boxCenter(1) - sNew / 2, 1), cameraParameters.ImageSize(2));
        y = min(max(boxCenter(2) - sNew / 2, 1), cameraParameters.ImageSize(1));
        w = min(sNew, cameraParameters.ImageSize(2) - x);
        h = min(sNew, cameraParameters.ImageSize(1) - y);

        rois = [x, y, w, h];
        
     end

end

