function S = computeInnovation(Pp, H, M, R)
%COMPUTEINNOVATION Compute innovation covariance for the kalman filter.
%The innovation is computed as S = H * P * H' + M * R * M'. H and M can
%either be arrays or cells of arrays. Pp and R are assumed to be the full
%covariance matrices hence they are used for each entry in (H, M).
%As a result all dimensions must be compatible, ie. H and M can arise from
%a single measurement but have to be jacobians wrt. all states and noises
%in Pp resp. R.
% inputs:
%   Pp                  Prior covariance matrix.
%   H                   Measurement jacobian.
%   M                   Measurement noise jacobian.
%   R                   Measurement covariance matrix.
% outputs:
%   S                   Innovation matrix.

    %% Compute innovation
    if iscell(H)
        
        S = cell(size(H, 1), 1);
        for i = 1 : size(H, 1)
            S{i} = computeInnovation(Pp, H{i}, M{i}, R);
        end
       
    else
        
        if isempty(H)
            S = [];
        else
            S = H * Pp * H' + M * R * M';
        end
        
    end 
end