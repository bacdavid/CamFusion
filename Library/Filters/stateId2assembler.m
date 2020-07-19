function assembler = stateId2assembler(stateId, kalmanFile)
%STATEID2ASSEMBLER Create assembler to assemble state jacobians.
% inputs:
%   id                  ID of the state.
%   kalmanParameters    Kalman parameters as described in the rest of
%                       library.
% outputs:
%   assembler           Bool assembler array.

    %% Create state assembler
    n = size(cat(1, kalmanFile.mu{:}), 1);
    assembler = false(n, 1);
    if stateId
        n1 = size(cat(1, kalmanFile.mu{1 : stateId - 1}), 1);
        n2 = size(cat(1, kalmanFile.mu{stateId + 1 : end}), 1);
        assembler(n1 + 1 : end - n2) = true;
    else
        return;
    end 
end