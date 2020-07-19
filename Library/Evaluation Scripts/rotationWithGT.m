% Load trajectories
v1 = load('trajectory_1.mat');
trajectory90 = v1.trajectory;
v2 = load('trajectory_2.mat');
trajectory180 = v2.trajectory;
v3 = load('trajectory_3.mat');
trajectory270 = v3.trajectory;
v4 = load('trajectory_4.mat'); 
trajectory360 = v4.trajectory;

% Process trajectories
stateIdx = 3; % First 3 are cameras, then markers, then objects
stack_len = 100;
t90 = cat(2, trajectory90.yBuffer{:});
t180 = cat(2, trajectory180.yBuffer{:});
t270 = cat(2, trajectory270.yBuffer{:});
t360 = cat(2, trajectory360.yBuffer{:});
t90 = cat(2, t90{stateIdx, :});
t180 = cat(2, t180{stateIdx, :});
t270 = cat(2, t270{stateIdx, :});
t360 = cat(2, t360{stateIdx, :});
t90 = t90(1 : 6, end - stack_len : end); % Only pose
t180 = t180(1 : 6, end - stack_len : end); % Only pose
t270 = t270(1 : 6, end - stack_len : end); % Only pose
t360 = t360(1 : 6, end - stack_len : end); % Only pose

% Average (not totally legit since angle axis is not additive - but for
% small angles we can assume so) & compute matrix
t90 = mean(t90, 2);
t180 = mean(t180, 2);
t270 = mean(t270, 2);
t360 = mean(t360, 2);
t90_lin = t90(1:3);
t180_lin = t180(1:3);
t270_lin = t270(1:3);
t360_lin = t360(1:3);
t90_rot = t90(4:6);
t180_rot = t180(4:6);
t270_rot = t270(4:6);
t360_rot = t360(4:6);

% State
y90 = [t90_lin; t90_rot]; % Not considering translation
y180 = [t90_lin; t180_rot];
y270 = [t90_lin; t270_rot];
y360  = [t90_lin; t360_rot];

% baseline
b = cv.Rodrigues(t90_rot);
b = b(:, 3); % Z vector
b(2) = 0; % Project onto X, Z plane
b = acosd(dot([0; 0; 1], b) / norm(b));

% GT
baseline_rot = b;
gt_lin = t90_lin; % use the first bit as linear gt
gt90_rot = cv.Rodrigues(roty(baseline_rot) * rotz(180)); % Change to rotx, roty, rotz
gt180_rot = cv.Rodrigues(roty(baseline_rot - 90) * rotz(180));
gt270_rot = cv.Rodrigues(roty(baseline_rot - 180) * rotz(180));
gt360_rot = cv.Rodrigues(roty(baseline_rot - 270) * rotz(180));
gt90_y = [gt_lin; gt90_rot];
gt180_y = [gt_lin; gt180_rot];
gt270_y = [gt_lin; gt270_rot];
gt360_y = [gt_lin; gt360_rot];

% Figure
[cameraHandles, markerHandles] = setCameraPlotV2([1, 2], [1, 2, 3, 4, 5, 6]);
updateCameraPlotV2({y360, gt360_y}, trajectory90.yBuffer{end}(4:9), cameraHandles, markerHandles)

