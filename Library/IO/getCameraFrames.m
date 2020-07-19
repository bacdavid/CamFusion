function frames = getCameraFrames(cameras)
%GETCAMERAFRAMES Obtain a cell of cameras frames from all cameras.
% inputs:
%   cameras            	Cell of cameras.
% outputs:
%   frames              Cell of frames, one per camera.

%% Get frames
    frames = {};
    for i = 1 : numel(cameras) % First trigger all, use parfor for parallel
        trigger(cameras{i}); 
    end
    for i = 1 : numel(cameras) % Get the frames from the buffer
        frames{end+1} = getdata(cameras{i}, 1);
    end
end