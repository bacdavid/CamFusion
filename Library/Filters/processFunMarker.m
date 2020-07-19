function [f, F, L] = processFunMarker(yMarker, idMarker, kalmanParameters)
%PROCESSFUNMARKER Process function of the marker. All, but
%"kalmanParameters", can be cells of arrays.
% inputs:
%   yMarker             Marker state.
%   idMarker            State ID of the marker.
%   kalmanParameters    Kalman parameters as described in the rest of
%                       library.
% outputs:
%   f                   Predicted state.
%   F                   Jacobian.
%   L                   Noise jacobian.

    %% Predict measurement of object
     if iscell(yMarker)
        
        f = cell(size(yMarker, 1), 1);
        F = cell(size(yMarker, 1), 1);
        L = cell(size(yMarker, 1), 1);
        for i = 1 : size(yMarker, 1)
            [f{i}, F{i}, L{i}] = processFunMarker(yMarker{i}, idMarker(i), kalmanParameters);
        end
        
    else
    
        % Process
        f = yMarker;

        % Jacobian
        FMarker = eye(size(yMarker, 1));

        stateAssembler = stateId2assembler(idMarker, kalmanParameters);
        F = zeros(size(f, 1), size(stateAssembler, 1));
        if any(stateAssembler); F(:, stateAssembler) = FMarker; end
        
        % Noise jacobian
        noiseAssembler = processNoiseId2assembler(0, kalmanParameters); % no noise
        L = zeros(size(f, 1), size(noiseAssembler, 1));

     end  
end