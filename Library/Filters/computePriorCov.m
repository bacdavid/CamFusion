function Pp = computePriorCov(P, F, L, Q)
%COMPUTEPRIORCOV Compute the prior covariance matrix. The prior covariance
%is computed as P_pior = F * P * F' + L * Q * L'. Inputs can either be
%arrays or cells of arrays.
% inputs:
%   P                   Posterior covariance.
%   F                  	Process jacobian.
%   L                   Process noise jacobian.
% outputs:
%   Q                   Process noise covariance.

    %% Compute prior covariance
    if iscell(P)
        
        Pp = cell(numel(P), 1);
        for i = 1 : numel(P)
            Pp{i} = computePriorCov(P{i}, F{i}, L{i}, Q{i});
        end
        
    else

        Pp = F * P * F' + L * Q * L';
    
    end
end