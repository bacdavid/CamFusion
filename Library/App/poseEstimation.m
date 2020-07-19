function results = poseEstimation(app)
%POSEESTIMATION Main function to run pose estimation. Very similar to
%FUSION but without the object detection.
% inputs:
%   app                 Application instance, can be replaced with a struct as
%                       longs as it contains the setup params.
% outputs:
%   results             Results table, check in code what it contains. Can easily
%                       be extended.
    %% Setup      
    restoreFlag = app.userConfig.restoreFlag;
    cameraDict = app.userConfig.cameraDict(end); % Only take last index   
    resolutionKey = app.userConfig.resolutionKey;
    markerDict = app.userConfig.markerDict;
    markerSize = app.userConfig.markerSize;
    pTheshMarker = app.userConfig.pThreshMarker;
    nInstances = app.userConfig.nInstances;
    nMarkers = numel(markerDict); nObjects = sum(nInstances);
    cameraParameters3 = app.params.cameraParameters3;
    [cameraHandles, markerHandles] = setCameraPlot(cameraDict, markerDict);
    markerFrameHandles = setMarkerDisplay(cameraParameters3.ImageSize, cameraDict);
    cameras = setCameraInput(cameraDict, resolutionKey);
    openCameras(cameras);
    kalmanParameters = loadKalmanParameters(app.userConfig);

    %% Start
   [y, P, Q, R] = initializeFilter(kalmanParameters);
    y = constructStateCell(y, kalmanParameters);
    if restoreFlag
        y_rest = app.params.trajectory.yBuffer{end};
        y(1 : 2) = y_rest(2:3);
        y(4 : 3 + nMarkers) = y_rest(4 : 3 + nMarkers); 
    end
    TBuffer{1, 1} = 0; yBuffer{1, 1} = y; PBuffer{1, 1} = P;
    tv = tic;

    while ~app.StopButton.Value
       
        %% Frames
        frames = getCameraFrames(cameras);
        frame3 = frames{1};

        %% Timings
        T = toc(tv);
        tv = tic;

        %% Process
        yp = {}; F = {}; L = {};

        % Cameras    
        [yp(1 : 2, 1), F(1 : 2, 1), L(1 : 2, 1)] = processFunCameraV2(y(1 : 2), 1 : 2, kalmanParameters); % Dummy, could be removed for efficiency
        [yp(3, 1), F(3, 1), L(3, 1)] = processFunCamera(y(3), T, 3, 1, kalmanParameters);
        [yp(4 : nMarkers + 3, 1), F(4 : nMarkers + 3, 1), L(4 : nMarkers + 3, 1)] = processFunMarker(y(4 : nMarkers + 3, 1), 4 : nMarkers + 3, kalmanParameters);

        % Objects
        [yp(nMarkers + 4 : nObjects + nMarkers + 3, 1), F(nMarkers + 4 : nObjects + nMarkers + 3, 1), L(nMarkers + 4 : nObjects + nMarkers + 3, 1)] = processFunObject(y(nMarkers + 4 : nObjects + nMarkers + 3), T, nMarkers + 4 : nObjects + nMarkers + 3, 2 : nObjects + 1, kalmanParameters); % Dummy, could be removed for efficiency

        F = cat(1, F{:}); L = cat(1, L{:});

        %% Prior Covariance
        Pp = computePriorCov(P, F, L, Q);

        %% Measurements
        % Markers
        % Detect markers
        [markers3, markerIds3, misc_detectedMarkers3] = detectMarkers(frame3, markerSize, markerDict, cameraParameters3);

        % Predict marker measurements
        [idMarker3, idMarkerFixed3] = associateMarkers(markerIds3, markerDict, 4 : nMarkers + 3);
        if app.FreezeMapButton.Value; idMarkerFixed3 = zeros(size(idMarkerFixed3)); end % Freeze markers
        idNoise3 = 3 * (idMarker3 - 3);
        [hCamera3, HCamera3, MCamera3] = measurementFunMarker(yp{3}, yp(idMarker3), 3, idMarkerFixed3, idNoise3, kalmanParameters);

        % Adjust marker axis
        markers3 = alignMarkerAxis(markers3, hCamera3);

        if app.FreezeMapButton.Value % Only eliminate outliers once frozen
            % Compute camera innovation
            SCamera3 = computeInnovation(Pp, HCamera3, MCamera3, R);
            
            % Eliminate outliers
            matchedIdxCamera3 = matchMarkers(markers3, hCamera3, SCamera3, pTheshMarker);

            % Gather
            zCamera3 = markers3(matchedIdxCamera3(:, 1));
            hCamera3 = hCamera3(matchedIdxCamera3(:, 2));
            HCamera3 = HCamera3(matchedIdxCamera3(:, 2));
            MCamera3 = MCamera3(matchedIdxCamera3(:, 2));
        else
            zCamera3 = markers3;
            hCamera3 = hCamera3;
            HCamera3 = HCamera3;
            MCamera3 = MCamera3;
        end

        % Combine all
        z = zCamera3; h = hCamera3; H = HCamera3; M = MCamera3;     
        z = cat(1, z{:}); h = cat(1, h{:}); H = cat(1, H{:}); M = cat(1, M{:});

        %% Recompute innovation
        S = computeInnovation(Pp, H, M, R);

        %% Kalman gain
        K = computeGain(Pp, H, S);

        %% Correction
        v = computeCorrection(z, h);

        %% Posterior cov
        P = computePosteriorCov(Pp, K, S);

        %% Posterior mean
        yp = constructStateVector(yp);
        y = computePosteriorMean(yp, v, K);
        y = constructStateCell(y, kalmanParameters);

        %% Plots
        markerFrameHandles = updateMarkerDisplay({misc_detectedMarkers3}, markerFrameHandles);
        [cameraHandles, markerHandles] = updateCameraPlot(y(3), y(4 : nMarkers + 3), cameraHandles, markerHandles);
        
        %% Append
        TBuffer{end + 1, 1} = TBuffer{end} + T; yBuffer{end + 1, 1} = y; PBuffer{end + 1, 1} = P;

    end
            
        %% Close all
        closeCameras(cameras);
        close all;
        
        %% Results
        trajectory = table(TBuffer, yBuffer, PBuffer);
        results = trajectory;

end