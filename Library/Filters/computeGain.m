function K = computeGain(Pp, H, S)
%COMPUTEGAIN Compute gain for kalman filter. Kalman gain is K = P * H' *
%inv(S). Please note that the pseudo inverse is used here since the kernel
%of S might be non-empty. Inputs can either be arrays or cells of arrays.
% inputs:
%   Pp                  Prediction covariance matrix.
%   H                   Measurement jacobian.
%   S                   Innovation covariance.
% outputs:
%   K                   Kalman gain.

    %% Compute gain
    if iscell(H)
        
        K = cell(numel(H), 1);
        for i = 1 : numel(H)
            K{i} = computeGain(Pp{i}, H{i}, S{i});
        end
        
    else
        
        if isempty(H)
            K = [];
        else
            K = Pp * H' * pinv(S);
        end
        
    end
end