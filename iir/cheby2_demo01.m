clc; close all; clear;

order = 5;
Rp = 1;
Wp = 0.3; % = Wn

[b, a] = cheby2(order, Rp, Wp, 'high');
figure;
freqz(b,a);
title('high');

[b, a] = cheby2(5, Rp, [0.3, 0.5], 'stop');
figure;
freqz(b,a);
title('bandpass');

figure;
zplane(b,a);

