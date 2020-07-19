function results = objectTracking(app)
%OBJECTTRACKING Main function to run object tracking. Very similar to
%FUSION but without the pose estimation.
% inputs:
%   app                 Application instance, can be replaced with a struct as
%                       longs as it contains the setup params.
% outputs:
%   results             Results table, check in code what it contains. Can easily
%                       be extended.
    %% Setup   
    restoreFlag = app.userConfig.restoreFlag;
    cameraDict = app.userConfig.cameraDict(1:2); % Only take first 2 indices
    resolutionKey = app.userConfig.resolutionKey;
    markerDict = app.userConfig.markerDict;
    markerSize = app.userConfig.markerSize;
    surfThreshold = app.userConfig.surfThreshold;
    nOctaves = app.userConfig.nOctaves;
    ambigRatio = app.userConfig.ambigRatio;
    nInstances = app.userConfig.nInstances;
    minDistance = app.userConfig.minDistance;
    minObjectSize = app.userConfig.minObjectSize;
    objectMatchingL2Weight = app.userConfig.objectMatchingL2Weight;
    pThreshObject = app.userConfig.pThreshObject;
    nMarkers = numel(markerDict); nObjects = sum(nInstances);
    cameraParameters1 = app.params.cameraParameters1;
    cameraParameters2 = app.params.cameraParameters2;
    genericObjectDict = 1 : nObjects;
    [cameraHandles, markerHandles, objectHandles] = setFusionPlot(cameraDict, markerDict, genericObjectDict);
    [objectFrameHandles, centerHandles, roiHandles] = setCenterDisplayROI(cameraParameters1.ImageSize, cameraDict);
    markerFrameHandles = setMarkerDisplay(cameraParameters1.ImageSize, cameraDict);
    cameras = setCameraInput(cameraDict, resolutionKey);
    openCameras(cameras);
    objectDict = app.params.objectDict;
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
        frame1 = frames{1}; frame2 = frames{2};

        %% Timings
        T = toc(tv);
        tv = tic;

        %% Process
        yp = {}; F = {}; L = {};

        % Cameras    
        [yp(1 : 2, 1), F(1 : 2, 1), L(1 : 2, 1)] = processFunCameraV2(y(1 : 2), 1 : 2, kalmanParameters);
        [yp(3, 1), F(3, 1), L(3, 1)] = processFunCamera(y(3), T, 3, 1, kalmanParameters); % Dummy, could be removed for efficiency
        [yp(4 : nMarkers + 3, 1), F(4 : nMarkers + 3, 1), L(4 : nMarkers + 3, 1)] = processFunMarker(y(4 : nMarkers + 3, 1), 4 : nMarkers + 3, kalmanParameters); % Dummy, could be removed for efficiency

        % Objects
        [yp(nMarkers + 4 : nObjects + nMarkers + 3, 1), F(nMarkers + 4 : nObjects + nMarkers + 3, 1), L(nMarkers + 4 : nObjects + nMarkers + 3, 1)] = processFunObject(y(nMarkers + 4 : nObjects + nMarkers + 3), T, nMarkers + 4 : nObjects + nMarkers + 3, 2 : nObjects + 1, kalmanParameters);

        F = cat(1, F{:}); L = cat(1, L{:});

        %% Prior Covariance
        Pp = computePriorCov(P, F, L, Q);

        %% Measurements
        % Markers
        if app.FreezeStereoPoseButton.Value % Freeze pose estimation for the stereo camera arrays
            zCamera1 = []; zCamera2 = [];
            hCamera1 = []; hCamera2 = [];
            HCamera1 = []; HCamera2 = [];
            MCamera1 = []; MCamera2 = [];
            misc_detectedMarkers1 = []; misc_detectedMarkers2 = [];
        else
            % (Detect markers)
            [markers1, markerIds1, misc_detectedMarkers1] = detectMarkers(frame1, markerSize, markerDict(1), cameraParameters1); % Only detect origin
            [markers2, markerIds2, misc_detectedMarkers2] = detectMarkers(frame2, markerSize, markerDict(1), cameraParameters2); % Only detect origin
            
            % (Predict marker measurements)
            [idMarker1, idMarkerFixed1] = associateMarkers(markerIds1, markerDict, 4 : nMarkers + 3);
            [idMarker2, idMarkerFixed2] = associateMarkers(markerIds2, markerDict, 4 : nMarkers + 3);
            idNoise1 = idMarker1 - 3; % stateId to noiseId, one per camera
            idNoise2 = 2 * (idMarker2 - 3);
            [hCamera1, HCamera1, MCamera1] = measurementFunMarker(yp{1}, yp(idMarker1), 1, idMarkerFixed1, idNoise1, kalmanParameters);
            [hCamera2, HCamera2, MCamera2] = measurementFunMarker(yp{2}, yp(idMarker2), 2, idMarkerFixed2, idNoise2, kalmanParameters);
        
            % (Adjust marker axis)
            markers1 = alignMarkerAxis(markers1, hCamera1);
            markers2 = alignMarkerAxis(markers2, hCamera2);
            
            % (Gather)
            zCamera1 = markers1; zCamera2 = markers2;
            hCamera1 = hCamera1; hCamera2 = hCamera2;
            HCamera1 = HCamera1; HCamera2 = HCamera2;
            MCamera1 = MCamera1; MCamera2 = MCamera2;
        end

        % Objects
        % Predict objects
        [hObject1, HObject1, MObject1] = measurementFunObject(yp{1}, yp(nMarkers + 4 : nObjects + nMarkers + 3), 0, nMarkers + 4 : nObjects + nMarkers + 3, 3 * nMarkers + 1 : 3 * nMarkers + nObjects, kalmanParameters);
        [hObject2, HObject2, MObject2] = measurementFunObject(yp{2}, yp(nMarkers + 4 : nObjects + nMarkers + 3), 0, nMarkers + 4 : nObjects + nMarkers + 3, 3 * nMarkers + 1 : 3 * nMarkers + nObjects, kalmanParameters); % meas. noise is the same; not for optimization so it's okay

        % Compute object innovations
        SObject1 = computeInnovation(Pp, HObject1, MObject1, R);
        SObject2 = computeInnovation(Pp, HObject2, MObject2, R);

        % Predict rois
        rois1 = predictROI(hObject1, SObject1, cameraParameters1, minObjectSize);
        rois2 = predictROI(hObject2, SObject2, cameraParameters2, minObjectSize);

        % Detect objects
        [centers1, centers2] = detectCentersStereoROI(frame1, frame2, rois1, rois2, objectDict, nInstances, minDistance, cameraParameters1, cameraParameters2, surfThreshold, nOctaves, ambigRatio);

        % Triangulate
        centers = triangulateCenters(y{1}, y{2}, centers1, centers2, cameraParameters1, cameraParameters2);

        % Match
        matchedIdxObject = matchCentersL2(centers, hObject1, objectMatchingL2Weight, pThreshObject); % wrt. camera 1

        % Gather
        zObject = centers(matchedIdxObject(:, 1));
        hObject = hObject1(matchedIdxObject(:, 2));
        HObject = HObject1(matchedIdxObject(:, 2));
        MObject = MObject1(matchedIdxObject(:, 2));

        % Combine all
        z = [zCamera1; zCamera2; zObject];
        h = [hCamera1; hCamera2; hObject];
        H = [HCamera1; HCamera2; HObject];
        M = [MCamera1; MCamera2; MObject];        
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
        markerFrameHandles = updateMarkerDisplay({misc_detectedMarkers1, misc_detectedMarkers2}, markerFrameHandles);
        [cameraHandles, markerHandles, objectHandles] = updateFusionPlot(y(1 : 2), y(4 : nMarkers + 3), y(nMarkers + 4 : nObjects + nMarkers + 3), cameraHandles, markerHandles, objectHandles);
        [objectFrameHandles, centerHandles, roiHandles] = updateCenterDisplayROI(frames, {centers1, centers2}, {rois1, rois2}, objectFrameHandles, centerHandles, roiHandles);
        
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