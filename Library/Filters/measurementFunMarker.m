function [h, H, M] = measurementFunMarker(ypCamera, ypMarker, idCamera, idMarker, idNoise, kalmanParameters)
%MEASUREMENTFUNMARKER Measurement function for the markers. Inputs, but
%"ypCamera", "kalmanParameters", and "idCamera", can be cells of arrays or
%arrays of scalars (for the IDs). Setting one of the IDs to "0" results in
%an empty jacobian thus no correction will happen.
% inputs:
%   ypCamera            Predicted camera.
%   ypMarker            Predicted markers.
%   idCamera            State ID of the camera.
%   idMarkers           State IDs of the markers.
%   idNoise             Noise IDs.
%   kalmanParameters    Kalman parameters as described in the rest of
%                       library.
% outputs:
%   h                   Predicted measurement.
%   H                   Jacobian.
%   M                   Noise jacobian.

    %% Predict measurement of marker
    if iscell(ypMarker)
        
        h = cell(numel(ypMarker), 1);
        H = cell(numel(ypMarker), 1);
        M = cell(numel(ypMarker), 1);
        for i = 1 : numel(ypMarker)
            [h{i}, H{i}, M{i}] = ...
                measurementFunMarker(ypCamera, ypMarker{i}, idCamera, ...
                idMarker(i), idNoise(i), kalmanParameters);
        end

    else

        % Measurement
        phi_IC = ypCamera(4:6);
        [R_CI, J1] = cv.Rodrigues(-phi_IC);
        I_r_IC = ypCamera(1:3);
        I_r_IM = ypMarker(1:3);
        I_r_CM = I_r_IM - I_r_IC;
        C_r_CM = R_CI * I_r_CM;
        phi_IM = ypMarker(4:6);
        [R_IM, J2] = cv.Rodrigues(phi_IM);
        R_CM = R_CI * R_IM;
        [phi_CM, J3] = cv.Rodrigues(R_CM);
        h = [C_r_CM; phi_CM];

        % Jacobians
        J1_reshape = [reshape(J1(1, :), 3, []), reshape(J1(2, :), 3, []), ...
            reshape(J1(3, :), 3, [])];
        J4 = reshape(-I_r_CM' * J1_reshape, 3, []); % Location wrt. pose
        J5 = -R_CI; % Location wrt. location
        J6 = R_CI; % Location wrt. marker location
        J7 = [J5, J4, zeros(3, 6)]; % Location wrt. cam state
        J8 = [J6, zeros(3, 3)]; % Location wrt. marker state
        J9 = -J1 * blockRepeatMatrix(3, R_IM) * J3; % Orientation wrt. orientation
        J10 = J2 * [ R_CI(1,1), 0, 0, R_CI(2,1), 0, 0, R_CI(3,1), 0, 0; ...
            0, R_CI(1,1), 0, 0, R_CI(2,1), 0, 0, R_CI(3,1), 0; ...
            0, 0, R_CI(1,1), 0, 0, R_CI(2,1), 0, 0, R_CI(3,1); ...
            R_CI(1,2), 0, 0, R_CI(2,2), 0, 0, R_CI(3,2), 0, 0; ...
            0, R_CI(1,2), 0, 0, R_CI(2,2), 0, 0, R_CI(3,2), 0; ...
            0, 0, R_CI(1,2), 0, 0, R_CI(2,2), 0, 0, R_CI(3,2); ...
            R_CI(1,3), 0, 0, R_CI(2,3), 0, 0, R_CI(3,3), 0, 0; ...
            0, R_CI(1,3), 0, 0, R_CI(2,3), 0, 0, R_CI(3,3), 0; ...
            0, 0, R_CI(1,3), 0, 0, R_CI(2,3), 0, 0, R_CI(3,3)] * J3; % Orientation wrt. marker orientation
        J11 = [zeros(3, 3), J9', zeros(3, 6)];  % Orientation wrt. cam state
        J12 = [zeros(3, 3), J10']; % Orientation wrt. marker state
        HCamera = [J7; J11];
        HMarker = [J8; J12];

        stateAssembler = stateId2assembler(idCamera, kalmanParameters);
        H = zeros(size(h, 1), size(stateAssembler, 1));
        if any(stateAssembler); H(:, stateAssembler) = HCamera; end % If one of the H shouldn't be included
        stateAssembler = stateId2assembler(idMarker, kalmanParameters);
        if any(stateAssembler); H(:, stateAssembler) = HMarker; end

        % Noise jacobians
        [Rn, J13] = cv.Rodrigues([0; 0; 0]); % Fix the mean at [0, 0, 0]
        J13_reshape = [reshape(J13(1, :), 3, []), reshape(J13(2, :), 3, []), ...
            reshape(J13(3, :), 3, [])];
        J14 = reshape((R_CI * I_r_CM)' * J13_reshape, 3, []);
        J15 = [eye(3), J14];
        [~, J16] = cv.Rodrigues(Rn * R_CI * R_IM);
        J17 = J13 * blockRepeatMatrix(3, R_CI * R_IM) * J16;
        J18 = [zeros(3), J17'];
        MCamera = [J15; J18];

        noiseAssembler = measurementNoiseId2assembler(idNoise, kalmanParameters);
        M = zeros(size(h, 1), size(noiseAssembler, 1));
        if any(noiseAssembler); M(:, noiseAssembler) = MCamera; end
 
    end
end