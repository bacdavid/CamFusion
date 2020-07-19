% Load trajectories
load('trajectory.mat');

% Process trajectories
stateIdx = 3; % First 3 are cameras, then markers, then objects
t = cat(2, trajectory.yBuffer{:});
t_f = cat(2, t{stateIdx, :});
t_f = t_f(1:3, :);
t = t_f(:, 450 : end-100); % Only lin

% Initial
t_init = mean(t_f(:, 450:500), 2);

% GT
b = 230; %233
c1 = t_init;
c2 = roty(b) * [0; 0; 1] * 0.92 + c1;
c3 = roty(b - 90) * [0; 0; 1] * 0.62 + c2;
c4 = roty(b - 180) * [0; 0; 1] * 0.92 + c3;
c = [c1, c2, c3, c4];

% Figure
markerHandles = setCameraPlotV3([1, 2, 3, 4, 5, 6]);
hold on;
updateCameraPlotV3(trajectory.yBuffer{end}(4:9), markerHandles);
plot3(c(1, :), c(2, :), c(3, :), '-r', 'LineWidth', 1);
plot3(t(1, :), t(2, :), t(3, :), '--og', 'LineWidth', 1, 'MarkerSize', 6);
hold off;

