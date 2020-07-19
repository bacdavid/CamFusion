% Load trajectory
load('trajectory.mat');

% Process trajectory
t = cat(2, trajectory.yBuffer{:});
t1 = cat(2, t{5, :}); % 1:3 Cameras, 4 Marker, 5 Obj 1, 6 Obj2
t2 = cat(2, t{6, :});
t1 = t1(1 : 3, 200:end); % Only location is relevant
t2 = t2(1 : 3, 200:end); % Only location is relevant

% Figure
figure;
xlabel('x [m]');
ylabel('y [m]');
zlabel('z [m]');
axis([-0.15, 0.15, -0.2, 0.2, -1.05, 0.5]);
%view(0, 90); % AZ, EL, front
view(0, 0); % topdown
grid on;
hold on;
plot3(t1(1, :), t1(2, :), t1(3, :), '--or', 'LineWidth', 1, 'MarkerSize', 6);
plot3(t2(1, :), t2(2, :), t2(3, :), '--og', 'LineWidth', 1, 'MarkerSize', 6);
hold off;