clear;clc;
% data
SIZE = power(2, 8); % number of samples 256
sampleFreq = 200; % [hz] the larger the sampleFreq, the larger the filterLength should be
cutoff = 12; % hz
filterLength = 21; % value ~ sampleFreq
order = filterLength - 1;
        
data = zeros(1, SIZE); % sample in which time point
for i=1:SIZE
    t = i / sampleFreq;
    data(i) = 10 * sin(2 * pi * 7 * t) + 5 * cos(2 * pi * 20 * t) + 2 * cos(2 * pi * 35 * t);
end

%%
blo = fir1(order, cutoff / (sampleFreq/2), 'low',rectwin(order + 1);
figure;
freqz(blo); title('blo')
out = filter(blo, 1, data); % (coef of data, coef of output, data)

%% plot
figure;
subplot(2,1,1)
plot(data)

subplot(2,1,2)
plot(out)
