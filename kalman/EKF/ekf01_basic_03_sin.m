clc; clear; close all;

% generate signal data
size = 100;
t = 1:size;
n = length(t);
X = zeros(2, size); % [p; v]

std = 1;
src = sin(t);
y = src + randn(1,size)*std; % measurement

P = [0.0001, 0; 0, 0];

% EKF
Q = [0.1, 0; 0, 0.001];
R = std^2;

figure; 
hold on; grid on;
for i=2:n
   % predict
   A = [1, 1; -1, 1];    % jacobi, deltaF / deltaX
   X_ = X(:, i-1) + [X(2, i-1); -X(1, i-1)]*1;
   P_ = A * P * A' + Q;
   
   % udpate
   C = [1, 0]; % jacobi, deltaH / deltaX
   K = P_ * C' * inv(C * P_ * C' + R);
   X(:, i) = X_ + K * (y(i) - X_(1));
   P = (eye(2) - K*C) * P_;

end
plot(t, src, 'k--');
plot(t, y, 'r', 'LineWidth',1);
plot(t, X(1, :), 'k', 'LineWidth', 2);
legend('src' ,'measure', 'filter');
xlabel('t');
ylabel('p');



