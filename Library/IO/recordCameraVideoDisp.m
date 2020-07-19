function [videos, timestamps] = recordCameraVideoDisp(videoLength, outputFolder, cameras)
%DEPRECATED!
%RECORDCAMERAVIDEODISP Same as RECORDCAMERAVIDEO but with a display active
%to view the frames.
% inputs:
%   videoLength         Length of video in second.
%   outputFolder        Folder to write to.
%   cameras             A cell of previously 'opened' cameras.
% outputs:
%   videos              A cell of video readers.
%   timestamps          A cell of arrays of timestamps for the frames.

%% Record frames
    if iscell(cameras)
        
        videoWriters = {};
        for i = 1 : numel(cameras)
            filename = sprintf('./%s/video%i.MP4', outputFolder, i);
            videoWriters{end+1} = VideoWriter(filename, 'MPEG-4');
            videoWriters{end}.FrameRate = 30; % Fix this
            videoWriters{end}.Quality = 100;
            
            open(videoWriters{end});
        end
        
    else
        filename = sprintf('./%s/video.MP4', outputFolder);
        videoWriters = VideoWriter(filename, 'MPEG-4');
        videoWriters.FrameRate = 30;
        videoWriters.Quality = 100;
        
        open(videoWriters);
        
    end
    
    videoPlayer = vision.VideoPlayer;       
    timestamps = [];
    totalT = 0;
    tic;
    while totalT < videoLength

        frames = getCameraFrames(cameras);
        t = toc;
        tic;
        
        
        
        timestamps = [timestamps; t];
        
        if iscell(frames)
            
            videoPlayer(cat(2, frames{:})); % Display all frames
            
            for i = 1 : numel(frames)
                writeVideo(videoWriters{i}, frames{i});
            end
            
        else
            
            videoPlayer(frames);
            
            writeVideo(videoWriters, frames);
            
        end
        
        pause(1 / 30); % Framerate
        
        totalT = totalT + t;
        
    end
    
    delete(videoPlayer);
    
    if iscell(videoWriters)
        
        % Close and reload
        
        videos = {};
        for i = 1 : numel(videoWriters)
            close(videoWriters{i});
            filename = sprintf('./%s/video%i.MP4', outputFolder, i);
            videos{i} = videoReader(filename);
        end
        
        
    else
        close(videoWriters);
        filename = sprintf('./%s/video.MP4', outputFolder);
        videos = videoReader(filename);
    end  
end

