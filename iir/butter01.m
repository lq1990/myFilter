clc; clear; close all;

% data
SIZE = power(2, 8); % number of samples 256
sampleFreq = 200; % [hz] the larger the sampleFreq, the larger the filterLength should be
cutoff = 13; % hz
filterLength = 5; % value ~ sampleFreq
order = filterLength - 1;

data = zeros(1, SIZE); % sample in which time point
for i=1:SIZE
    t = i / sampleFreq;
    data(i) = 10 * sin(2 * pi * 7 * t) + 5 * cos(2 * pi * 20 * t) + 2 * cos(2 * pi * 35 * t); % 7, 20, 35
end

%% filter
wn1 = cutoff / (sampleFreq/2);
wn2 = 0.5;
[coefX, coefY] = butter(order, [wn1], 'high'); % butterworth
figure;
freqz(coefX, coefY); title('freqz of coefX')
figure;
zplane(coefX, coefY);

% filter
out = filter(coefX, coefY, data); % (coef of data, coef of output, data)

%% plot
figure;
subplot(2,1,1)
plot(data); grid on; hold on;

subplot(2,1,2)
plot(out); grid on;
