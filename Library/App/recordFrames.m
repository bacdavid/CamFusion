function results = recordFrames(app)
%RECORDFRAMES Main function to record frames.
% inputs:
%   app                 Application instance, can be replaced with a struct as
%                       longs as it contains the setup params.
% outputs:
%   results             Returns a "1" once done. The frames themselfes are directly
%                       written to a folder.
    %% Setup
    outputFolder = app.userConfig.outputFolder;
    cameraDict = app.userConfig.cameraDict;
    resolutionKey = app.userConfig.resolutionKey;
    nFrames = app.userConfig.nFrames;
    cameras = setCameraInput(cameraDict, resolutionKey);
    openCameras(cameras);
    
    %% Record
    recordFrameSelectionDisp(nFrames, outputFolder, cameras);
    
    %% Close all
    closeCameras(cameras);
    
    %% Results
    results = 1;

end