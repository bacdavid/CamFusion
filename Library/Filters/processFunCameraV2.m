function [f, F, L] = processFunCameraV2(yCamera, idCamera, kalmanParameters)
%PROCESSFUNCAMERAV2 Process function of the camera, opposed to
%PROCESSFUNCAMERA this function assumes that the camera is static, ie.
%cameras for stereo triangulartion. All, but "kalmanParameters", can be
%cells of arrays. Setting one of the IDs to "0" results in an empty
%jacobian thus no correction will happen.
% inputs:
%   yCamera             Camera state.
%   idCamera            State ID of the camera.
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
            [f{i}, F{i}, L{i}] = processFunCameraV2(yCamera{i}, idCamera(i), kalmanParameters);
        end
        
    else
    
        % Process
        f = yCamera;

        % Jacobian
        FCamera = eye(size(yCamera, 1));
        stateAssembler = stateId2assembler(idCamera, kalmanParameters);
        F = zeros(size(f, 1), size(stateAssembler, 1));
        if any(stateAssembler); F(:, stateAssembler) = FCamera; end

        % Noise jacobian
        noiseAssembler = processNoiseId2assembler(0, kalmanParameters); % no noise
        L = zeros(size(f, 1), size(noiseAssembler, 1));
    
    end    
end