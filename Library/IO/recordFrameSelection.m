function frameSelection = recordFrameSelection(nFrames, outputFolder, cameras)
%DEPRECATED!
%RECORDFRAMESELECTION Record  a frame every 0.5 second.
% inputs:
%   nFrames          	Number of frames to record
%   outputFolder        Folder to write to.
%   cameras             A cell of previously 'opened' cameras.
% outputs:
%   frameSelection      Image set with the frames.

%% Record frames 
    F = {};
    totalFrames = 0;
    totalT = 0;
    tic;
    while totalFrames < nFrames

        frames = getCameraFrames(cameras);
        t = toc;
        tic;
        
        totalT = totalT + t;
        
        if totalT > totalFrames * 0.5
            F{end+1} = frames;
            totalFrames = totalFrames + 1;
        end
        
    end
    
    frames = F{1};
    if iscell(frames)
        
        for i = 1 : numel(frames)
            filename = sprintf('./%s/camera%i', outputFolder, cameras{i}.DeviceID);
            mkdir(filename);
        end
        
    else
        
        filename = sprintf('./%s/camera%i', outputFolder, cameras.DeviceID);
        mkdir(filename);
        
    end
            
    
    for i = 1 : numel(F)
        
        frames = F{i};
        
        if iscell(frames)
            
            for j = 1 : numel(frames)
                filename = sprintf('./%s/camera%i/frame%09d.png', outputFolder, cameras{j}.DeviceID, i);
                imwrite(frames{j}, filename);
            end
            
        else
            
            filename = sprintf('./%s/camera%i/frame%09d.png', outputFolder, cameras.DeviceID, i);
            imwrite(frames, filename);
            
        end
        
    end
    

    if iscell(frames)
        
        frameSelection = {};
        for i = 1 : numel(frames)
            filename = sprintf('./%s/camera%i', outputFolder, i);
            frameSelection{i} = imageSet(filename);
        end
        
    else
        
        filename = sprintf('./%s/camera', outputFolder);
        frameSelection = imageSet(filename);
        
    end   
end

