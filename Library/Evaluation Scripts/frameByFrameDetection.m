% Load camera parameters
load('cameraParameters3_RGB24_640x480.mat');

% Load trajectory
load('trajectory_3.mat');

% Process trajectory
img = trajectory.frameBuffer;
t = cat(2, trajectory.yBuffer{:});
tcam = cat(2, t{3, :});
t1 = cat(2, t{5, :}); % 1:3 Cameras, 4 Marker, 5 Obj 1, 6 Obj2
%t2 = cat(2, t{6, :});
tcam = tcam(1 : 6, :); % Cam pose
t1 = t1(1 : 3, :); % Only location is relevant
%t2 = t2(1 : 3, :); % Only location is relevant

% Figure
figure;
fh = imshow(zeros([cameraParameters3.ImageSize, 3]));
ph = patch('XData', 1, 'YData', 1, 'FaceColor', 'none');

for i = 1 : numel(img)
    
    %hold on;
    
    % Image
    I = img{i};
    I = undistortImage(I, cameraParameters3);
    fh.CData = I;
    
    % roi
    h = measurementFunObjectV3(tcam(:, i), {t1(:, i)});
    r = predictROIV2(h, cameraParameters3, 0.1);
    if isempty(r); r = [1, 1, 0, 0]; end
    [x, y] = rois2Patches(r);
    ph.XData = x; ph.YData = y;
    pause;
    
    %hold off;
    
    disp(fprintf('frame %i / %i', i, numel(img)))
    
end

disp('DONE!')