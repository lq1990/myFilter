clc; clear; close all;

% ============================================
% EKF 对于强非线性的问题，效果有限。
% ============================================

% extended kalman filter
% nonlinear model,but s.t. gauss distribution
% x(k) = sin(3*sin(k-1))
% y(k) = x(k)^2, 注意似然概率是多峰分布，具有强烈的非线性。当y=4时，x=2 or -2.

% generate signal data
t = 0.01:0.01:1;
n = length(t);
x = zeros(1, n);
y = zeros(1, n);
x(1) = 0.1;
y(1) = 0.1^2;

coef = 2;
std = 10;
for i=2:n
   x(i) = sin(coef*x(i-1)) + cos(coef * x(i-1)); % F = sin(coef * x)+cos(coef * x)
   y(i) = x(i)+normrnd(0, std); % H = x
end

% EKF
Xplus = zeros(1,n);
Pplus = 0.1;
Xplus(1) = 0.1;
Q = 0.000001;
R = std^2;

for i=2:n
    % predict
    A = coef*cos(coef*Xplus(i-1)) - coef*sin(coef * Xplus(i-1)); % A = deltaF / deltaX
    X_ = sin(coef*Xplus(i-1)) + cos(coef*Xplus(i-1)); % X_ is prior, Xplus is posterior
    P_ = A * Pplus * A' + Q;
    
    % update using measurement
    C = 1; % C = deltaH / deltaX
    K = P_ * C * inv(C * P_ * C' + R);
    Xplus(i) = X_ + K * (y(i) - X_); % y - h(x)
    Pplus = (eye(1) - K*C)*P_;
end


% plot
figure;
hold on; grid on;
plot(t, x, 'k--', t, y, 'b', 'LineWidth', 1);
plot(t, Xplus, 'k', 'LineWidth', 2);
legend('x: src without noise', 'y: measure', 'filtered');

mse1_measure = mse(x, y);
mse2_filtered = mse(x, Xplus);
