function openCameras(cameras)
%OPENCAMERAS Open a cell of cameras. Use this before capturing with the
%cameras.
% inputs:
%   cameras            	Cell of cameras.
% outputs:
%   ---

%% Open cameras
    for i = 1 : numel(cameras)
        start(cameras{i});
    end     
end