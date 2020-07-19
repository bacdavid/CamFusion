% Load trajectory
load('trajectory.mat');

% Process trajectory
stateIdx = 5; % First 3 are cameras, then markers, then objects
t = cat(2, trajectory.yBuffer{:});
t = cat(2, t{stateIdx, 1:end});
t = t(1 : 3, :); % Only location is relevant

% Ground truth square
origin = [0; 0; 0];
len = 0.3;
c1 =  origin;
c2 = c1 + [0; 1; 0] * len;
c3 = c2 + [1; 0; 0] * len;
c4 = c3 + [0; -1; 0] * len;
c5 = c1;
c = [c1, c2, c3, c4, c5];

% Figure
figure;
xlabel('x [m]');
ylabel('y [m]');
zlabel('z [m]');
axis([-0.1, 0.6, -0.1, 0.6, -0.1, 0.6]);
view(0, 90); % AZ, EL
grid on;
hold on;
plot3(c(1, :), c(2, :), c(3, :), '-r', 'LineWidth', 1);
plot3(t(1, :), t(2, :), t(3, :), '--og', 'LineWidth', 1, 'MarkerSize', 6);
hold off;