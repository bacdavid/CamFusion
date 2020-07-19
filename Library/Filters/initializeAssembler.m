function assembler = initializeAssembler(kalmanParameters)
%DEPRECATED!
%INITIALIZEASSEMBLER Returns a cell of state assemblers, these are bool
%arrays that are only true for the length of a partial state. For example
%if you have two partial states of length 2 and 3. This function returns a
%cell with {[t, t, f, f, f], [f, f, t, t, t]}. This assemblers can come in
%handy to assamble partial jacobians into full jacobians, where most values
%are zero.
%   kalmanParameters    Kalman parameters as described in the rest of
%                       library.
% outputs:
%   assembler           Cell of assemblers.

    %% Initize assmeblers
    n = size(cat(1, kalmanParameters.mu{:}), 1); % total number
    idx = 1;
    assembler = cell(n, 1);
    for i = 1 : size(kalmanParameters.mu, 1)
        m = size(kalmanParameters.mu{i}, 1);
        stateId = zeros(n, 1);
        stateId(idx : idx + m - 1) = ones(m, 1);
        idx = idx + m;
        assembler{i} = stateId; 
    end
end