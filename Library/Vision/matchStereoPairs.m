function [matchedCenters1, matchedCenters2] = matchStereoPairs(centers1, centers2)
%MATCHSTEREOPAIRS Match a batch of centers1 to a batch of centers2. The
%approach used minimizes the distance between centers if both centers are
%assumed to be in the same image. This might be a slighly handwavy
%approach, an alternative is epipolar search.
% inputs:
%   centers1            2d centers in image 1.
%   centers2            2d centers in image 2.
% ouputs:
%   matchedCenters1     Centers1 in rearranged order to match centers 2.
%   matchedCenters2     Centers2 in rearranged order to match centers 1.

    %% Match centers
    % Compute all distances
    n = size(centers1, 1);
    idx = combvec(1 : n, 1 : n);
    idx = [idx(2, :); idx(1, :)];
    c1 = centers1(idx(1, :), :);
    c2 = centers2(idx(2, :), :);
    d = vecnorm(c1 - c2, 2, 2);
    d = reshape(d, n, n)';
    
    % Total dist
    idx = perms(1 : n);
    idx = reshape(idx', [], 1);
    r = repmat(1 : n, 1, factorial(n))';
    d = d(sub2ind(size(d), r, idx));
    d = reshape(d, n, [])';
    d = sum(d, 2);
    [~, matchIdx] = min(d);
    
    % Gather
    idx1 = reshape(r, n, [])';
    idx2 = reshape(idx, n, [])';
    idx1 = idx1(matchIdx, :);
    idx2 = idx2(matchIdx, :);
    matchedCenters1 = centers1(idx1, :);
    matchedCenters2 = centers2(idx2, :);    
end