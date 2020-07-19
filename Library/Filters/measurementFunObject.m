function [h, H, M] = measurementFunObject(ypCamera, ypObject, idCamera, idObject, idNoise, kalmanParameters)
%MEASUREMENTFUNOBJECT Measurement function for the markers. Inputs, but
%"ypCamera", "kalmanParameters", and "idCamera", can be cells of arrays or
%arrays of scalars (for the IDs). Setting one of the IDs to "0" results in
%an empty jacobian thus no correction will happen.
% inputs:
%   ypCamera            Predicted camera.
%   ypObject            Predicted markers.
%   idCamera            State ID of the camera.
%   idObject            State IDs of the markers.
%   idNoise             Noise IDs.
%   kalmanParameters    Kalman parameters as described in the rest of
%                       library.
% outputs:
%   h                   Predicted measurement.
%   H                   Jacobian.
%   M                   Noise jacobian.

    %% Predict measurement of object
    if iscell(ypObject)
        
        h = cell(numel(ypObject), 1);
        H = cell(numel(ypObject), 1);
        M = cell(numel(ypObject), 1);
        for i = 1 : numel(ypObject)
            [h{i}, H{i}, M{i}] = ...
                measurementFunObject(ypCamera, ypObject{i}, idCamera, ...
                idObject(i), idNoise(i), kalmanParameters);
        end

    else
        
        % Measurement
        I_r_IC = ypCamera(1:3);
        I_r_IO = ypObject(1:3);
        [R_CI, J1] = cv.Rodrigues(-ypCamera(4:6));
        h = R_CI * (I_r_IO - I_r_IC);

        % Jacobians
        HCamera = [-R_CI, blockRepeatMatrix(3, (I_r_IO - I_r_IC)') * -J1']; % Second term by chain rule
        HObject = [R_CI, zeros(3)];
        
        stateAssembler = stateId2assembler(idObject, kalmanParameters);
        H = zeros(size(h, 1), size(stateAssembler, 1));
        if any(stateAssembler); H(:, stateAssembler) = HObject; end % If one of the H shouldn't be included
        stateAssembler = stateId2assembler(idCamera, kalmanParameters);
        if any(stateAssembler); H(:, stateAssembler) = HCamera; end

        % Noise jacobians
        MObject = eye(3);
        
        noiseAssembler = measurementNoiseId2assembler(idNoise, kalmanParameters);
        M = zeros(size(h, 1), size(noiseAssembler, 1));
        if any(noiseAssembler); M(:, noiseAssembler) = MObject; end
 
    end           
end