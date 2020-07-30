clc; clear; close all;

%% butter
[b,a] = butter(5, 0.3, 'low');
y = filter(b,a, src);

figure;
freqz(b,a);

%% butter
clc; clear;
src = 0:8;

[b,a] = butter(2, [0.2], 'low');
y = filter(b,a, src);

figure;
freqz(b,a);

%% cheby1
[b,a] = cheby1(7, 1, [0.3], 'high');
y = filter(b,a, src);

figure;
freqz(b,a);

%% cheby2
[b,a] = cheby2(5, 50, [0.2, 0.5], 'bandpass');
y = filter(b,a, src);

figure;
freqz(b,a);

%% ellip
clc; clear;
src = 0:8;

n = 5;
Rp = 0.5;
Rs = 30;
Wp = [0.2, 0.5];
[b,a] = ellip(n, Rp, Rs, Wp, 'stop'); % Դ�벻ȫ , ltipack.sszero() missed
y = filter(b,a, src);

figure;
freqz(b,a);

%%

figure;
grid on; hold on;
plot(src);
plot(y, 'LineWidth', 2);
legend('src', 'y');


