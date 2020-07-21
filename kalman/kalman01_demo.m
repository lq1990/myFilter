% clc;clear; close all;
% % generate data
% dt = 1;
% size = 200;
% a = zeros(size, 1); % acceleration
% a(10:15) = 0.1; a(50:55) = -0.1;
% 
% t= 1:size;
% v = ones(size, 1)*0.1;
% std = 5;
% noise =std*randn(size, 1); % gauss noise
% 
% srcY = zeros(size, 1)+10;
% for i=2:size
%     v(i) = v(i-1) + a(i)*1;
%     srcY(i) = srcY(i-1)+ v(i)*1 + 1/2 * a(i) * 1*1;
% end
% Y = srcY + noise; % Y is measured position

% % set params
% A = [1 dt; 0 1]; % state transition matrix
% B = [dt*dt/2; dt];
% u = a;
% Q = [0.001, 0; 0 0.001]; % Cov matrix of model or outside uncertainty
% C = [1, 0]; % observe matrix, only position is observed, z = H * [p; v]
% R = std*std; % observe noise Cov. same as noise with var
% X = [10; 0]; % init state [p; v]
% P = [0,0;0,0]; % init P
% 
% filtered = zeros(size, 1);

% data
% ...
% set params
% ...

% predict and update
for i=1:size
   % predict x_,P_
   X_ = A*X + B*u(i);
   P_ = A*P*A'+Q; 
   
   % update x,P using z
   K = P_*C'/(C*P_*C' + R); % kalman gain
   X= X_ + K*(Y(i) - C*X_); % optimal state estimation
   P = (eye(2) - K*C) * P_; 
%      
%    filtered(i) = C*X; % filtered response
end

figure;
hold on; grid on;
plot(t, Y);
plot(t, filtered);

mse1 = mse(srcY, Y);
mse2 = mse(srcY, filtered);


