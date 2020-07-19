function y = computePosteriorMean(yp, v, K)
%COMPUTEPOSTERIORMEAN Compute the posterior mean. The posterior mean is
%computed as y_posterior = y + K * v. Inputs can either be arrays or cells
%of arrays. Note that a cell of yp's can be shorter than a cell of v's
%since there might not be a measurement for each predicted state. All yp's
%must correspond v's: yp_1 - v_1, .... yp_n - v_n, yp_n+1 - non existent,
%yp_n+2 - non existent, ...
% inputs:
%   yp                  Prior mean.
%   v                   Correction.
%   K                   Kalman gain.
% outputs:
%   y                   Posterior mean.

    %% Compute posterior mean
    if iscell(v)

        y = cell(size(yp, 1), 1);
        for i = 1 : numel(v)
            y{i} = computePosteriorMean(yp{i}, v{i}, K{i});
        end
        
        for i = size(v, 1) + 1 : size(yp, 1) % Remaining ones
            y{i} = yp{i};
        end
        
    else
        
        if isempty(v)
            y = yp;
        else
            y = yp + K * v;
        end
        
    end
end

