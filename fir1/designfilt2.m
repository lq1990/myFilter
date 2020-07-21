clear;clc;close all;

Fs = 2000;
N = power(2, 8);

data = zeros(1, N); % sample in which time point
for i=1:N
    t = i / Fs;
    data(i) = 10 * sin(2 * pi * 70 * t) + 5 * cos(2 * pi * 200 * t) + 2 * cos(2 * pi * 500 * t);
end

% tn = (0:N-1)/Fs;
nfilt = 20;
Fst = 460; % cutoff

d = designfilt('lowpassfir', 'FilterOrder', nfilt, 'CutoffFrequency', ...
               Fst, 'SampleRate', Fs, 'DesignMethod', 'window', ...
               'Window', 'rect');
           

xf = filter(d, data);

% plot(data)
% hold on, plot(xf,'-r','linewidth',1.5), hold off
% xlabel 'Time (s)', legend('Original Signal','Filtered Signal')
% 
% figure;
% freqz(d.Coefficients);
% 
% figure;
% plot(d.Coefficients)


%% filter
order = nfilt;
sampleFreq = Fs;
cutoff = Fst;

% f1=fir1(nfilt, cutoff/(sampleFreq/2), 'HIGH', hamming(nfilt+1), 'scale'); % 2st param: 0-1, 1 means: half sampleFreq
% f1 = fir1(20,[0.3, 0.4],'stop', rectwin(21), 'scale') % First_Band = 1
f1 = fir1(20,0.3,'low', rectwin(21), 'scale'); % 1
f2 = fir1(20,0.3,'high', rectwin(21), 'scale'); % 0
f3 = fir1(20,[0.3, 0.4],'bandpass', rectwin(21), 'scale'); % 0
f4 = fir1(20,[0.3, 0.4],'stop', rectwin(21), 'scale'); % 1
disp(f1)
disp(sum(f1))
figure;
plot(f1);

figure;
freqz(f1)

% First_Band
% low = 1
% high = 0
% bandpass = 0
% stop = 1

