function [xPatch, yPatch] = rois2Patches(rois)
%ROIS2PATCHES Transform a rois (x, y, w, h) into a patch (X, Y). Inputs can
%either be arrays or cells of arrays.
% inputs:
%   rois            	ROIs.
% outputs:
%   xPatch              x entries of the patch.
%   yPatch              y entries of the patch.

%% Transform ROIs to Patches
    xPatch = [];
    yPatch = [];
    
    if iscell(rois)
        
        for i = 1 : numel(rois)
            roi = rois{i};
            x = [roi(1); roi(1) + roi(3); roi(1) + roi(3); roi(1)];
            xPatch = [xPatch, x];
            y = [roi(2); roi(2); roi(2) + roi(4); roi(2) + roi(4)];
            yPatch = [yPatch, y];
        end
        
    else
        
        for i = 1 : size(rois, 1)
            roi = rois(i, :);
            x = [roi(1); roi(1) + roi(3); roi(1) + roi(3); roi(1)];
            xPatch = [xPatch, x];
            y = [roi(2); roi(2); roi(2) + roi(4); roi(2) + roi(4)];
            yPatch = [yPatch, y];
        end
        
    end  
end

