function Arep = blockRepeatMatrix(n, A)
%BLOCKREPEATMATRIX Repeat a matrix A along the diagonal.
% inputs:
%   n                   Number of repeats.
%   A                   Matrix to repeat.
% outputs:
%   Arep              	Result.

%% Block repeat matrix
    Arep = kron(eye(n), A);
end