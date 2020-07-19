function assembler = processNoiseId2assembler(id, kalmanParameters)
%PROCESSNOISEID2ASSEMBLER Create assembler to assemble noise jacobians.
% inputs:
%   id                  ID of the noise.
%   kalmanParameters    Kalman parameters as described in the rest of
%                       library.
% outputs:
%   assembler           Bool assembler array.

    %% Create noise assembler
    n = size(cat(1, kalmanParameters.q{:}), 1);
    assembler = false(n, 1);
    n1 = size(cat(1, kalmanParameters.q{1 : id - 1}), 1);
    n2 = size(cat(1, kalmanParameters.q{id + 1 : end}), 1);
    assembler(n1 + 1 : end - n2) = true;
end