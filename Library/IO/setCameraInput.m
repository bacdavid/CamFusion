function cameras = setCameraInput(cameraIds, resolutionKey)
%SETCAMERAINPUT Define a cell of cameras. "cameraIds" can be an array of
%IDs, whereas "resoltionKey" is used for all cameras. If you wish to use
%this function with various resolution keys, say if you have various
%different cameras, you will have to slighly modify the code.
% inputs:
%   camerasIds            	Array of IDs.
%   resolutionKey           Resolution key for all cameras.
% outputs:
%   cameras                 Cell of cameras, don't forget to open them.

%% Set cameras   
    cameras = {};
    for id = cameraIds
        cameras{end+1} = videoinput('winvideo', id, resolutionKey);
        triggerconfig(cameras{end}, 'manual');
        set(cameras{end}, 'TriggerRepeat', Inf);
        set(cameras{end}, 'FramesPerTrigger', 1);
    end         
end