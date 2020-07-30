

[coefX, coefY] = butter(11, 0.3*2*pi , 's');

figure;
freqz(coefX, coefY);