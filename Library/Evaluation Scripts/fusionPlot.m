% Load trajectories
load('trajectory.mat');

% Process trajectories
t = cat(2, trajectory.yBuffer{:});
tcam = cat(2, t{3, :});
tcam = tcam(1:3, :);
tcam = tcam(:, 1 : end); % Only lin

tst1 = cat(2, t{1, :});
tst1 = tst1(1:6, :);
tst1 = tst1(:, end); % End
tst2 = cat(2, t{2, :});
tst2 = tst2(1:6, :);
tst2= tst2(:, end); % End

tobj1 = cat(2, t{5, :});
tobj1 = tobj1(1:3, :);
tobj1= tobj1(:, 1:end); % End
% tobj2 = cat(2, t{6, :});
% tobj2 = tobj2(1:3, :);
% tobj2 = tobj2(:, 1:end); % End

% Figure
markerHandles = setCameraPlotV3(1); 
hold on;
updateCameraPlotV3(trajectory.yBuffer{end}(4), markerHandles);
plotCamera('Size', 0.05, 'Location', tst1(1:3), 'Orientation', cv.Rodrigues(tst1(4:6))', 'Color', 'r', 'Opacity', 0.2);
plotCamera('Size', 0.05, 'Location', tst2(1:3), 'Orientation', cv.Rodrigues(tst2(4:6))', 'Color', 'r', 'Opacity', 0.2);
plot3(tcam(1, :), tcam(2, :), tcam(3, :), '--or', 'LineWidth', 1, 'MarkerSize', 6);
plot3(tobj1(1, :), tobj1(2, :), tobj1(3, :), '--og', 'LineWidth', 1, 'MarkerSize', 6);
%plot3(tobj2(1, :), tobj2(2, :), tobj2(3, :), '--*g', 'LineWidth', 1, 'MarkerSize', 6);
hold off;