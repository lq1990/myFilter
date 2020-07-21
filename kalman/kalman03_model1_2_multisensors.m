
% Q, R is hard to determine, experience matters

clc;clear;close all;
% ===============================================
% X(t) = F * X(t-1) + Q   state prediction
% Y(t) = H * X(t) + R   measurement model
% ===============================================

t = 0.1:0.01:2;
L = length(t);

x = zeros(1, L); % real signal
y=x; % measurement
y2 = x; % measurement from second sensor

std1 = 1;
std2 = 0.9;
% generate signal
for i=1:L
    x(i) = sin(2*pi*t(i));
%     x(i) = t(i)^2;
    y(i)=x(i) + normrnd(0, std1); % mean, std
    y2(i) = x(i) + normrnd(0, std2);
end

% figure;
% plot(t,x,t,y,'LineWidth',2); grid on;
% legend('src', 'measured'); % src can not got acutally


%% filter
% prediction formula, is hard to create. It is important that measurement
% is precise.

%% model 1. build an inexact model firstly
F1 = 1;
H1 = 1;
Q1 = 0.5; % if Q1 is smaller that R, more to this predcition, less to that measure
R1 = std1*std1; % Q 和R，谁小 就趋近于谁。

% init x(k)+
Xplus1 = zeros(1, L);
Xplus1(1) = 1;
Pplus1 = 0.01^2;

% kalman filter design begins
for i=2:L
    % prediction
    Xminus1 = F1 * Xplus1(i-1);
    Pminus1 = F1 * Pplus1 * F1' + Q1;

    % update
    K1 = (Pminus1 * H1') * inv(H1 * Pminus1 * H1' + R1);
    Xplus1(i) = Xminus1 + K1 * (y(i) - H1 * Xminus1);
    Pplus1 = (eye(1) - K1 * H1) * Pminus1;

end

figure;
plot(t,x,'r','LineWidth',1); hold on; grid on;
plot(t, Xplus1, 'k', 'LineWidth', 2); grid on; hold on;
plot(t, y, 'b', 'LineWidth',1); grid on;
title('filtered');
legend('src','filtered of model 1','measure');

mseVal_1sensor_model1 = mse(x, Xplus1); % target, output

%% model 2
% 使用 [p; v; a] 向量来表示 X。即：考虑位移、速度、加速度
% 也是相当于高阶的多项式来拟合，表示实际场景。毕竟多项式拟合比直线拟合要好很多。
% 提高阶数的方法：
% a
% at + b
% at^2 / 2 + bt + c
% at^3 / 6 + bt^2/2 + ct + d
% 上面的若从高阶到低阶，就是简单的对t求导。

% 那么：当只用0阶的多项式时，就是上面的model 1

% [p;    [ 1   dt   dt^2 / 2 ;
%  v;  =   0   1      dt;    * [p; v; a]
%  a]      0   0       1]

dt = t(2) - t(1);

F = [1, dt, dt^2/2; 
    0,  1,     dt; 
    0,  0,     1];

H = [1, 0, 0]; % only position is measured
Q = [0.05, 0, 0;
     0, 0.01, 0;
     0, 0, 0.001]; % 使用协方差矩阵，是因为p/v/a可能两两他们噪声之间有联系。
R = std1*std1; % 观测的不确定性，这里只有一个传感器。如果有多个传感器，有多个观测值，那么这里也应该是协方差矩阵。

% init
X = zeros(3, L);
X(1,1) = 0.01;
X(2,1) = 0;
X(3,1) = 0;

P = [0.01, 0,   0;
     0,   0.01, 0;
     0,   0,    0.01];
 
 for i=2:L
    % pred
    X_ = F * X(:, i-1);
    P_ = F * P * F' + Q;

    % update
    K = P_ * H' * inv(H * P_ * H' + R);
    X(:, i) = X_ + K*(y(i) - H*X_);
    P = (eye(3) - K*H) * P_;
 end
 

figure;
plot(t,x,'r','LineWidth',1); hold on; grid on;
plot(t, X(1, :), 'k', 'LineWidth', 2); grid on; hold on;
plot(t, y, 'b', 'LineWidth',1); grid on;
title('filtered of model 2');
legend('src','filtered','measure');

mseVal_1sensor_model2 = mse(x, X(1,:)); % target, output



% model2 处理的信号滤波，可以用fir1来做，滤波效果更好。
% 但是：kalman filter优点：实时在线滤波。


%% multi sensors
% y1(t) = x(t) + R1;
% y2(t) = x(t) + R2;
% H = [1, 0, 0; 1st sensor
%      1, 0, 0]; 2st sensor
% 
% Q; % a Cov matrix
% R; % a Cov matrix

dt = t(2) - t(1);

F = [1, dt, dt^2/2; 
    0,  1,     dt; 
    0,  0,     1];

H = [1, 0, 0; 
     1, 0, 0]; % only position is measured
Q = [0.05, 0, 0;
     0, 0.01, 0;
     0, 0, 0.001]; % 使用协方差矩阵，是因为p/v/a可能两两他们噪声之间有联系。
R = [std1*std1, 0;
     0,  std2*std2]; % 观测的不确定性，这里只有一个传感器。如果有多个传感器，有多个观测值，那么这里也应该是协方差矩阵。

% init
X = zeros(3, L);
X(1,1) = 0.01;
X(2,1) = 0;
X(3,1) = 0;

P = [0.01, 0,   0;
     0,   0.01, 0;
     0,   0,    0.01];
 
 for i=2:L
    % pred
    X_ = F * X(:, i-1);
    P_ = F * P * F' + Q;

    % update
    K = P_ * H' * inv(H * P_ * H' + R);
    disp(K)
    X(:, i) = X_ + K*([y(i);y2(i)] - H*X_);
    P = (eye(3) - K*H) * P_;
 end
 

figure;
plot(t,x,'r','LineWidth',1); hold on; grid on;
plot(t, X(1, :), 'k', 'LineWidth', 2); grid on; hold on;
plot(t, y, 'b', 'LineWidth',1); grid on;
plot(t, y2, 'g', 'LineWidth',1);
title('filtered of model 3 with 2 sensors');
legend('src','filtered','sensor1', 'sensor2');


mseVal_2sensors = mse(x, X(1,:)); % target, output

