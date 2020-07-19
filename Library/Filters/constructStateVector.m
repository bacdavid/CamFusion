function stateVector = constructStateVector(stateCell)
%CONSTRUCTSTATEVECTOR Construct full state vector from a cell of partial
%state vectors.
% inputs:
%   stateCell           Cell of partial state vectors.
% outputs:
%   stateVector         Stack of the entries in the state cell.

    %% Construct state vector
    stateVector = cell2mat(stateCell);
end