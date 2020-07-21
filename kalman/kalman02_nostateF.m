clc;clear;

% ==============================
% time-varying Kalman Filter design
% 
% if F = 0
% 
% ==============================

size = 100;
t = 1:size;
Z = 10*sin(t/10); % observe values¡£ position is observed,
std = 1;
noise =std*randn(1, size); % gauss noise with var
Z = Z + noise;

% init state of X,P
X = [0]; % state [p; v]
P = [1]; % Cov matrix of state

F = 1; % state transition matrix

% we are sure model uncertainty is low
Q = 1; % Cov matrix of model or external uncertainty

H = 1; % observe matrix
R = std*std; % observe noise Cov. same as noise with var

filtered = zeros(1, size);

for i=1:size
    % predict x_,P_
   X_ = F*X; % Bu = 0
   P_ = F*P*F'+Q; 
   
   % update x,P using z
   K = P_*H'/(H*P_*H' + R); % kalman coef
   X= X_ + K*(Z(i) - H*X_);
   P = (eye(1) - K*H) * P_; 
   
   filtered(i) = H*X; % filtered response
end

figure;
plot(1:size, Z, 'r', 'LineWidth', 2); hold on; grid on;
plot(1:size, filtered, 'b', 'LineWidth', 2);
legend('observed position','optimal predicted postion or filtered', 'Location', 'NW');


