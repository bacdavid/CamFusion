function P = computePosteriorCov(Pp, K, S)
%COMPUTEPOSTERIORCOV Compute the posterior covariance matrix. The posterior
%covariance is computed as P_posterior = P - K * S * K'. Please note that
%if P is empty we have P_posterior = P. Inputs can either be arrays or
%cells of arrays.
% inputs:
%   Pp                  Prior covariance matrix.
%   K                   Kalman gain.
%   S                   Innovation covariance.
% outputs:
%   P                   Posterior covariance.

    %% Compute posterior covariance
     if iscell(S)

        P = cell(size(Pp, 1), 1); % Observed
        for i = 1 : size(S, 1)
            P{i} = computePosteriorCov(Pp{i}, S{i}, K{i});
        end
        
        for i = size(S, 1) + 1 : size(Pp, 1) % Remaining ones
            P{i} = Pp{i};
        end
 
     else
         
        if isempty(K)
            P = Pp;
        else
            P = Pp - K * S * K';
        end
        
     end
end