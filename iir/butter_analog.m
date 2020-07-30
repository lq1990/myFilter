n = 5;
f = 20;

[zb,pb,kb] = butter(n,2*pi*f,'s');
[bb,ab] = zp2tf(zb,pb,kb);
[hb,wb] = freqs(bb,ab,4096);

figure;
plot(wb/2/pi, hb); grid on;
xlabel('hz');
ylabel('freq response');

figure;
freqz(bb,ab);

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

% filter
y = filter(bb,ab, data);
figure;
plot(data); hold on;
plot(y, 'k', 'LineWidth',2);
legend('src data','filtered');


