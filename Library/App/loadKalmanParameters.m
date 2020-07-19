function kalmanParameters = loadKalmanParameters(userConfig)
%LOADKALMANPARAMETERS Helperfunction to process a app.useConfig struct into
%kalman parameters. To check for the meaning of the different value please
%refer to the "setup" section. 
% inputs:
%   userConfig          User config usually from app.userConfig. However, can be
%                       replaced with any as long as the params are contained.
% outputs:
%   kalmanParameters    Kalman parameters in a struct. Can be used with
%                       with functions of this library.
%% Setup
    kalmanParameters.mu(1:2, 1) = {zeros(12, 1)}; % Camera 1 % 2 initial state
    kalmanParameters.mu(3, 1) = {zeros(12, 1)}; % Camera 3 initial state
    kalmanParameters.mu(4:numel(userConfig.markerDict) + 3, 1) = {zeros(6, 1)}; % Markers intial states
    kalmanParameters.mu(numel(userConfig.markerDict) + 4 : numel(userConfig.markerDict) + sum(userConfig.nInstances) + 3, 1) = {zeros(6, 1)}; % Objects initial states
    kalmanParameters.sigma(1:2, 1) = {eye(12) * 1e5}; % Camera 1 & 2 initial cov
    kalmanParameters.sigma(3, 1) = {zeros(12) * 1e5}; % Camera 3 initial cov
    kalmanParameters.sigma(4:numel(userConfig.markerDict) + 3, 1) = {eye(6) * 1e5}; % Marker intial cov
    kalmanParameters.sigma(numel(userConfig.markerDict) + 4:numel(userConfig.markerDict) + sum(userConfig.nInstances) + 3, 1) = {eye(6) * 1e5}; % Object initial cov
    kalmanParameters.q(1, 1) = {zeros(6, 1)}; % Keep at zero
    kalmanParameters.q(2:sum(userConfig.nInstances) + 1, 1) = {zeros(3, 1)}; % keep at zero
    kalmanParameters.Q(1, 1) = {diag([userConfig.qCameraLin, userConfig.qCameraLin, userConfig.qCameraLin, userConfig.qCameraAng, userConfig.qCameraAng, userConfig.qCameraAng])}; % Camera process cov                
    kalmanParameters.Q(2:sum(userConfig.nInstances) + 1, 1) = {eye(3) * userConfig.qObjectLin}; % Object process cov
    kalmanParameters.r(1:3 * numel(userConfig.markerDict), 1) = {zeros(6, 1)}; % Keep at zero
    kalmanParameters.r(3 * numel(userConfig.markerDict) + 1:3 * numel(userConfig.markerDict) + sum(userConfig.nInstances), 1) = {zeros(3, 1)}; % Keep at zero
    kalmanParameters.R(1:2 * numel(userConfig.markerDict), 1) = {diag([userConfig.rStereoCamerasPos, userConfig.rStereoCamerasPos, userConfig.rStereoCamerasPos, userConfig.rStereoCamerasOrient, userConfig.rStereoCamerasOrient, userConfig.rStereoCamerasOrient])}; % Marker measurement cov for stereo cams
    kalmanParameters.R(2 * numel(userConfig.markerDict) + 1:3 * numel(userConfig.markerDict), 1) = {diag([userConfig.rCameraPos, userConfig.rCameraPos, userConfig.rCameraPos, userConfig.rCameraOrient, userConfig.rCameraOrient, userConfig.rCameraOrient])}; % Marker measurement cov for moving cam
    kalmanParameters.R(3 * numel(userConfig.markerDict) + 1:3 * numel(userConfig.markerDict) + sum(userConfig.nInstances), 1) = {eye(3) * userConfig.rObjectPos}; % Object measurement cov

end