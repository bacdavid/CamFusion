function stateCell = constructStateCell(stateVector, kalmanParameters)
%CONSTRUCTSTATECELL Decompose a full state vector into a cell of partial
%state vectors.
% inputs:
%   stateVector         Full state vector.
%   kalmanParameters    Kalman parameters as described in the rest of
%                       library.
% outputs:
%   stateCell           Cell of partial state vectors.

    %% Construct state cell
    stateCell = cell(size(kalmanParameters.mu, 1), 1);
    idx = 1;
    for i = 1 : size(kalmanParameters.mu, 1)
        stateCell{i} = stateVector(idx : idx + size(kalmanParameters.mu{i}, 1) - 1);
        idx = idx + size(kalmanParameters.mu{i}, 1);
    end     
end

