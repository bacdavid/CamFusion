function frameSelection = snapFrameSelectionDisp(outputFolder, cameras)
%DEPRECATED!
%SNAPFRAMESELECTION Manually press a button to trigger a frame.
% inputs:
%   outputFolder        Folder to write to.
%   cameras             A cell of previously 'opened' cameras.
% outputs:
%   frameSelection      Image set with the frames.

%% Record frames 
    figure;

    % bottom handles
    stopButton = uicontrol('Style', 'PushButton', 'String', 'Stop recording', ... 
        'Callback', 'delete(gcf)');
    snapButton = uicontrol('Style', 'PushButton', 'String', 'Snap image', ... 
        'Callback', @fixButton, 'Position', [20, 50, 60, 20]);
    guidata(snapButton, 0);
    
  
    videoPlayer = vision.VideoPlayer;
    F = {};
    while ishandle(stopButton)
        
        try
        
            frames = getCameraFrames(cameras);

            if iscell(frames)
                videoPlayer(cat(2, frames{:})); % Display all frames
            else
                videoPlayer(frames);
            end

            if guidata(snapButton)

                if iscell(frames)
                    imshow(cat(2, frames{:})); % Display all frames
                else
                    imshow(frames);
                end

                F{end+1} = frames;
                guidata(snapButton, 0);
            end
            
        catch
            
            break;
            
        end
        
    end
    
    delete(videoPlayer);
    
    frames = F{1};
    if iscell(frames)
        
        for i = 1 : numel(frames)
            filename = sprintf('./%s/camera%i', outputFolder, i);
            mkdir(filename);
        end
        
    else
        
        filename = sprintf('./%s/camera', outputFolder);
        mkdir(filename);
        
    end
            
    
    for i = 1 : numel(F)
        
        frames = F{i};
        
        if iscell(frames)
            
            for j = 1 : numel(frames)
                filename = sprintf('./%s/camera%i/frame%09d.png', outputFolder, j, i);
                imwrite(frames{j}, filename);
            end
            
        else
            
            filename = sprintf('./%s/camera/frame%09d.png', outputFolder, i);
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


function fixButton(src, event) % For the button to work
    guidata(src, 1);
end