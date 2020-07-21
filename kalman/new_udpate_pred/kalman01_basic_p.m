clc;clear;
close all;
% ==============================
% time-varying Kalman Filter design
% params given by user:
% 
% 
% ==============================

dt = 1; % => sampleFreq is 1hz, 1time/1s
size = 100;
a = zeros(1, size);

t= 1:size;
% Z = dt * t + 0.5*a*t.^2; % observe values¡£ position is observed, 1m 2m 3m...
v = ones(size, 1);
std = 5;
noise =std*randn(size, 1); % gauss noise with var

srcZ = zeros(size, 1);
for i=2:size
    v(i) = v(i-1) + a(i)*1;
    srcZ(i) = srcZ(i-1)+ v(i)*1 + 1/2 * a(i) * 1*1;
end
Z = srcZ + noise;

srcZ = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99];
Z = [-6.16439172025251,-10.8052861484443,5.72211961746316,3.49345357079880,5.58398098558389,5.21624137356011,-0.680132638086114,12.8025947726678,18.3231111490010,10.4637270227422,12.0785205899529,11.6354202958292,14.7085984606886,11.3897819652223,8.92023486050678,17.3909478768067,15.1680401929385,17.5390185302060,11.3413861135939,23.3531381626099,20.9025535598297,18.2443731155905,15.0046848536715,25.6461765516077,24.4939591753573,27.9336959602117,27.2666475256263,34.7715527916775,26.3526424068790,27.2866837426016,30.4568146438639,38.6290120642547,30.5082565715090,33.4889389298892,35.3808075788753,34.6893874929399,35.6277139930325,33.6715414651140,34.0333961413715,36.9676388493732,39.8749057028312,43.3379409792149,35.2157368360428,51.0716800705131,42.8795116580096,44.2063995135503,52.3112494027873,45.4675808843888,50.9580684756893,45.9823663156402,42.1080522151533,51.8042535411501,50.4043111298748,57.7648722656982,46.8255474017852,59.7151988228763,53.5509446093271,60.4275827761705,61.1275099926735,60.2802690925486,60.2598701392655,57.0420322831596,65.6125606628959,64.3522498590313,71.0443112090918,62.9266952142418,71.1675511291265,78.0494407460321,66.0389234513691,66.7468616593036,69.6412722008178,70.5660472853483,68.6682323892062,75.7387497835433,73.5919295503254,76.5187306360387,74.2477794145904,90.4284067864982,82.0239798979462,82.2277375800584,82.8016653976757,77.7155830176258,84.8572208753543,77.1581380919383,93.9456066162951,89.1140795991436,75.5256648023940,89.0765519859708,86.4463083081490,91.3657610701166,90.3134213875082,94.5348053340103,92.0390165820252,88.7747772375952,94.0558962357277,100.066203587215,95.5396759635368,94.3967863210727,99.1557219383153,94.5769342582191];


% init state of X,P
X = [0; 0]; % state [p; v]
P = [1 0; 0 1]; % Cov matrix of state
% P = [0,0;0,0];

F = [1 dt; 0 1]; % state transition matrix

B = [0; 0];
u = a;

% we are sure model uncertainty is low
Q = [0.001, 0; 0 0.001]; % Cov matrix of model or outside uncertainty
% Q = [0.1 ,0; 0, 0.01];

H = [1, 0]; % observe matrix, only position is observed, z = H * [p; v] + r
R = std*std; % observe noise Cov. same as noise with var

figure;
hold on; grid on;

x_pred = zeros(1,size);
v_pred = zeros(1,size);
filtered = zeros(size, 1);

for i=1:size
       % update x,P using z
       K = P * H' * inv(H * P * H' + R); % kalman coef
       X= X + K * (Z(i) - H * X);
       P = (eye(2) - K * H) * P; 

       x_pred(i) = X(1);
       v_pred(i) = X(2);
       filtered(i) = H * X; % filtered response
       plot(X(1), X(2), 'k.'); % [p, v]

       % predict x_,P_
       X = F * X + B * u(i);
       P = F * P * F' + Q; 
  
end
xlabel('position');
ylabel('velocity');

figure;
plot(1:size, Z, 'r-.', 'LineWidth', 2); hold on; grid on;
plot(1:size, filtered, 'k', 'LineWidth', 2);
plot(1:size, srcZ, 'b--', 'LineWidth', 2);
xlabel('time');
ylabel('position');
legend('measured position','filtered', 'src without noise', 'Location', 'NW');

mse_filtered = mse(srcZ, filtered);
mse_measure = mse(srcZ, Z);

%% simulink
ydata.time = 1:size;
ydata.signals.values = Z;
udata.time = 1:size;
udata.signals.values = u;

sim('sim_kalman03_p_u.slx')

figure;
plot(Z,'r','LineWidth',1); hold on; grid on;
plot(filtered, 'k', 'LineWidth', 2);
plot(srcZ, 'b', 'LineWidth', 2);
plot(xe1.signals.values, 'k--', 'LineWidth',2);
title('p u');
legend('sensor1','filtered', 'src without noise', 'sim');

figure;
hold on; grid on;
plot(filtered, 'k', 'LineWidth', 2);
plot(srcZ, 'b', 'LineWidth', 2);
plot(xe1.signals.values, 'k--', 'LineWidth',2);
title('code vs. sim');
legend('filtered', 'src without noise', 'sim');


mse1_code=mse(srcZ, filtered);
mse2_sim=mse(srcZ, xe1.signals.values);





