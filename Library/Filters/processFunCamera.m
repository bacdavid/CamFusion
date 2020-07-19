function [f, F, L] = processFunCamera(yCamera, T, idCamera, idNoise, kalmanParameters)
%PROCESSFUNCAMERA Process function of the camera. All, but "T" and
%"kalmanParameters", can be cells of arrays. Setting one of the IDs to "0"
%results in an empty jacobian thus no correction will happen.
% inputs:
%   yCamera             Camera state.
%   T                   Time step.
%   idCamera            State IDs of the camera.
%   idNoise             Noise IDs.
%   kalmanParameters    Kalman parameters as described in the rest of
%                       library.
% outputs:
%   f                   Predicted state.
%   F                   Jacobian.
%   L                   Noise jacobian.

    %% Predict measurement of object
    if iscell(yCamera)
        
        f = cell(size(yCamera, 1), 1);
        F = cell(size(yCamera, 1), 1);
        L = cell(size(yCamera, 1), 1);
        for i = 1 : size(yCamera, 1)
            [f{i}, F{i}, L{i}] = processFunCamera(yCamera{i}, T, idCamera(i), idNoise(i), kalmanParameters);
        end
        
    else

        % Process
        f1 = yCamera(1:3) + T * yCamera(7:9);
        f2 = yCamera(4:6) + T * yCamera(10:12);
        f3 = yCamera(7:9);
        f4 = yCamera(10:12);

        f = [f1; f2; f3; f4];

        % Jacobians
        J1 = [eye(3), zeros(3), eye(3) * T, zeros(3)];
        J2 = [zeros(3), eye(3), zeros(3), eye(3) * T];
        J3 = [zeros(3, 6), eye(3), zeros(3)];
        J4 = [zeros(3, 9), eye(3)];

        FCamera = [J1; J2; J3; J4];
        
        stateAssembler = stateId2assembler(idCamera, kalmanParameters);
        F = zeros(size(f, 1), size(stateAssembler, 1));
        if any(stateAssembler); F(:, stateAssembler) = FCamera; end

        % Noise jacobians
        Jn1 = [eye(3) * T^2/2, zeros(3)];
        Jn2 = [zeros(3), eye(3) * T^2/2];
        Jn3 = [eye(3) * T, zeros(3)];
        Jn4 = [zeros(3), eye(3) * T];

        LCamera = [Jn1; Jn2; Jn3; Jn4];
        
        noiseAssembler = processNoiseId2assembler(idNoise, kalmanParameters);
        L = zeros(size(f, 1), size(noiseAssembler, 1));
        if any(noiseAssembler); L(:, noiseAssembler) = LCamera; end
        
    end
end