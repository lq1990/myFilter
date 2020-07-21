clc; clear; close all;

% y1(t) = x(t) + R1;
% y2(t) = x(t) + R2;
% H = [1, 0, 0; 1st sensor
%      1, 0, 0]; 2st sensor
% 
% Q; % a Cov matrix
% R; % a Cov matrix
t = 0:0.01:.09;
L = length(t);
z = zeros(L , 2);

std = 10;
for i=1:L
    x(i) = 3*sin(10*pi*t(i));
% %     x(i) = t(i)^2;
    z(i, 1)=x(i) + normrnd(0, std); % mean, std
    z(i, 2) = x(i) + normrnd(0, std*0.9);
end
% 
z = [18.0449377172419,-6.50809331613376;
    6.19252136062043,-1.41520677223021;
    7.76478084496372,7.10873291771619;
    -19.4331651443575,-9.51633736255778;
    -11.5569664275037,6.46977002224380;
    17.7020128084852,0.0586719409268444;
    10.9763995952934,7.76303048062050;
    -8.08927211208364,6.00425394528262;
    -5.75559162994150,15.4097578266910;
    0.601385891180035,15.6510478986295]   ;


% X = [p; v; a]

dt = 0.1;

F = [1, dt, dt^2/2; 
    0,  1,     dt; 
    0,  0,     1];

H = [1, 0, 0; 
     1, 0, 0]; % only position is measured
Q = [0.5, 0, 0;
     0, 0.01, 0;
     0, 0, 0.001]; % 使用协方差矩阵，是因为p/v/a可能两两他们噪声之间有联系。
%  Q = [1,0,0; 0,1,0; 0,0,1];
R = [std, 0;
     0,  std*0.9]; % 观测的不确定性，这里只有一个传感器。如果有多个传感器，有多个观测值，那么这里也应该是协方差矩阵。

% init
X = zeros(3, 1); % [p; v; a]
X(1,1) = 0;
P = [0,   0,   0;
     0,   0,   0;
     0,   0,    0];
 
output = zeros(size(z, 1), 1);
 
 for i=1:size(z, 1)
    % update
    K = P * H' * inv(H * P * H' + R);
    disp(K)
    X = X + K*(z(i, :)' - H*X);
    P = (eye(3) - K*H) * P;
    
    output(i) = X(1);
    
    % pred
    X = F * X;
    P = F * P * F' + Q;
 end
 

figure;
plot(z(:, 1),'r','LineWidth',1); hold on; grid on;
plot(z(:, 2),'g','LineWidth',1);
plot(output, 'k', 'LineWidth', 2);
plot(x, 'b-.', 'LineWidth', 2);

title('filtered of model 3 with 2 sensors');
legend('sensor1', 'sensor2','filtered', 'src without noise');

data.time=0:length(t)-1;
data.signals.values=z;

%% after simulink:sim_kalman02.slx
figure;
plot(z(:, 1),'r','LineWidth',1); hold on; grid on;
plot(z(:, 2),'g','LineWidth',1);
plot(output, 'k', 'LineWidth', 2);
plot(x, 'b-.', 'LineWidth', 2);
plot(xe1.signals.values, 'k--', 'LineWidth',2);

title('filtered of model 3 with 2 sensors');
legend('sensor1', 'sensor2','filtered', 'src without noise', 'sim');

figure;
plot(output, 'k', 'LineWidth', 2); hold on; grid on;
plot(xe1.signals.values(1:110), 'k--', 'LineWidth',2);
legend('filtered', 'simulink');

mse1_code=mse(x', output);
mse2_sim=mse(x', xe1.signals.values(1:110));


