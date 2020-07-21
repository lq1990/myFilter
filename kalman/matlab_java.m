clc;clear;close all;
Z=[
-2.4176
7.0265
6.8472
7.3883
2.7848
9.5635
5.3768
1.9823
18.4983
9.0456
12.7870
16.0824
15.9005
13.0573
15.6567
9.6949
17.3202
18.0526
20.3134
22.9420
19.0881
32.0304
20.8278
19.6394
31.4572
14.5783
32.0982
37.2189
24.4842
24.8370
25.3636
31.1959
20.1378
38.5762
41.8069
39.8614
32.1636
41.3718
29.3565
44.6959
38.7675
43.3829
38.5292
36.5258
46.1994
47.6311
47.5340
56.6276
46.8999
58.3194
54.4183
48.0220
49.5615
46.1139
63.4367
60.1677
53.6996
57.6955
58.8804
56.1629
59.4687
64.3904
58.9816
67.8731
70.6763
78.2743
67.8801
66.8293
76.5347
65.5699
70.6134
64.3705
63.1208
72.7200
74.8438
80.8192
77.4188
86.0083
85.8860
89.5815
75.0790
91.2596
77.7893
78.8222
94.0131
85.0618
78.0212
96.2767
82.0149
98.0867
99.1272
90.3488
94.4128
93.2672
88.3575
101.0454
89.7099
101.5170
101.2009
98.3517];

size = length(Z);
% init state of X,P
X = [0; 0];
P = [1 0; 0 1];

F = [1 1; 0 1];
Q = [0,0; 0,0];

H = [1, 0]; % observe matrix, only position is observed, z = H * [p; v] + r
R = 25; % observe noise Cov. same as noise with var

figure;
hold on; grid on;

filtered = zeros(1, size);

for i=1:size
    % predict x_,P_
   X_ = F*X; % Bu = 0
   P_ = F*P*F'+Q; 
   
   % update x,P using z
   K = P_*H'/(H*P_*H' + R); % kalman coef
   X= X_ + K*(Z(i) - H*X_);
   P = (eye(2) - K*H) * P_; 
   
   filtered(i) = H*X; % filtered response
   plot(X(1), X(2), 'k.'); % [p, v]
end
xlabel('position');
ylabel('velocity');

figure;
plot(1:size, Z, 'r-.', 'LineWidth', 2); hold on; grid on;
plot(1:size, filtered, 'k', 'LineWidth', 2);
legend('observed position','optimal predicted postion or filtered', 'Location', 'NW');



