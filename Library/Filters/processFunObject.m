function [f, F, L] = processFunObject(yObject, T, idObject, idNoise, kalmanFile)
%PROCESSFUNOBJECT Process function of the object. All, but "T" and
%"kalmanParameters", can be cells of arrays.
% inputs:
%   yObject             Object state.
%   T                   Time step.
%   idObject            State IDs of the object.
%   idNoise             Noise IDs.
%   kalmanParameters    Kalman parameters as described in the rest of
%                       library.
% outputs:
%   f                   Predicted state.
%   F                   Jacobian.
%   L                   Noise jacobian.

    %% Predict measurement of object
    if iscell(yObject)
        
        f = cell(size(yObject, 1), 1);
        F = cell(size(yObject, 1), 1);
        L = cell(size(yObject, 1), 1);
        for i = 1 : size(yObject, 1)
            [f{i}, F{i}, L{i}] = processFunObject(yObject{i}, T, idObject(i), idNoise(i), kalmanFile);
        end
        
    else
            
        % Process
        f1 = yObject(1:3) + T * yObject(4:6);
        f2 = yObject(4:6);
        f = [f1; f2];

        % Jacobians
        J1 = [eye(3), eye(3) * T];
        J2 = [zeros(3), eye(3)];
        FObject = [J1; J2];
        
        stateAssembler = stateId2assembler(idObject, kalmanFile);
        F = zeros(size(f, 1), size(stateAssembler, 1));
        if any(stateAssembler); F(:, stateAssembler) = FObject; end

        % Noise jacobians
        Jn1 = eye(3) * T^2/2;
        Jn2 = eye(3) * T;
        LObject = [Jn1; Jn2];
    
        noiseAssembler = processNoiseId2assembler(idNoise, kalmanFile);
        L = zeros(size(f, 1), size(noiseAssembler, 1));
        if any(noiseAssembler); L(:, noiseAssembler) = LObject; end
        
    end
end