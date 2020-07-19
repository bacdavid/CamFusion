function v = computeCorrection(z, h)
%COMPUTECORRECTION Compute the correction for the kalman filter. Correction
%is computed as v = z - h. Inputs can either be arrays or cells of arrays.
% inputs:
%   z                   Measurements.
%   h                   Predicted measurements.
% outputs:
%   v                   Correction.

    %% Compute correction
    if iscell(z)

        v = cell(numel(z), 1);
        for i = 1 : numel(z)
            v{i} = computeCorrection(z{i}, h{i});
        end
        
    else
        
        if isempty(z)
            v = [];
        else
            v = z - h;
        end
    
    end
end