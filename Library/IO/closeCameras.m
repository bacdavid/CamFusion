function closeCameras(cameras)
%CLOSECAMERAS Close a cell of cameras. Use this after having opened the
%cameras.
% inputs:
%   cameras            	Cell of cameras.
% outputs:
%   ---

%% Close cameras
    for i = 1 : numel(cameras)
        delete(cameras{i});
    end
end

