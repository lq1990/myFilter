clc; close all; clear;


Rp = 1;
Wp = 0.3; % = Wn

[b, a] = cheby1(9, Rp, [0.1, 0.3], 'stop');
figure;
freqz(b,a);
title('high');

% [b, a] = cheby1(2, 1, [0.3, 0.5], 'stop');
% figure;
% freqz(b,a);
% title('bandpass');

figure;
zplane(b,a);

