function results = recordObjects(app)
%RECORDOBJECTS Main function to record objects for dictionary.
% inputs:
%   app                 Application instance, can be replaced with a struct as
%                       longs as it contains the setup params.
% outputs:
%   results             Dictionary that can be used with the rest of the functions
%                       in this library.
    %% Setup
    outputFolder = app.userConfig.outputFolder;
    cameraDict = app.userConfig.cameraDict;
    resolutionKey = app.userConfig.resolutionKey;
    nFeatures = app.userConfig.nFeatures;
    surfThreshold = app.userConfig.surfThreshold;
    nOctaves = app.userConfig.nOctaves;
    cameraParameters = app.params.cameraParameters;
    cameras = setCameraInput(cameraDict, resolutionKey);
    openCameras(cameras);
    frameHandles = setDisp(cameraParameters.ImageSize, cameraDict);
    axHandles = setSURFDisp(cameraParameters.ImageSize, cameraDict);
    
    %% Record
    Image = {}; Points = {}; Features = {}; 
    id = 1;
    while ~app.CompileButton.Value

        % Frames
        frames = getCameraFrames(cameras);
        frame = frames{1};
        
        % Disp
        frameHandles = updateDisp({frame}, frameHandles);
        
        % Snap
        if app.SnapButton.Value
            [features, points, frame] = detectStrongestFeatures(nFeatures, frame, cameraParameters, surfThreshold, nOctaves);
            axHandles = updateSURFDisp({frame}, {points}, axHandles);
            if isempty(points)
                disp('No point are detected, not added')
            else
                Image{end + 1, 1} = frame;
                Points{end + 1, 1} = points;
                Features{end + 1, 1} = features;
            end
            app.SnapButton.Value = 0;
        end
            
        % Next
        if app.SaveObjectButton.Value
            if isempty(Points)
                disp('Snap an image first before adding a new object')
            else
                object = table(Image, Points, Features);
                save(sprintf('%s/object%i.mat', outputFolder, id), 'object');
                Image = {};
                Points = {};
                Features = {};
                id = id + 1;
            end
            app.SaveObjectButton.Value = 0;
        end

    end

    %% Close all
    closeCameras(cameras);
    close all;
    
    %% Results
    % Load all
    ObjectId = {}; ImageId = {}; Image = {}; Points = {}; Features = {};
    list = dir(sprintf('%s/*.mat', outputFolder));
    basename = list.folder;
    id = 1;
    for i = 1 : numel(list)
        name = fullfile(basename, list(i).name);
        load(name); % Load as "object"
        for j = 1 : size(object, 1)
            n = size(object{j, 2}{1}, 1); % N points
            ObjectId{end+1, 1} = ones(n, 1) * i; % Each object has a unique ID
            ImageId{end+1, 1} = ones(n, 1) * id; % Each frame has a unique ID
            id = id + 1;
            Image{end+1, 1} = object{j, 1}{1};
            Points{end+1, 1} = object{j, 2}{1};
            Features{end+1, 1} = object{j, 3}{1};
        end
    end
            
    objectDict = table(ObjectId, ImageId, Image, Points, Features);
    results = objectDict;

end