clc;clear;
%% high pass
fsamp = 1000; % sample freq
fcuts = [200 300]; % cutoff
mags = [1 0]; % lowpass
devs = [0.01 0.01]; % ripple

[n,Wn,beta,ftype] = kaiserord(fcuts,mags,devs,fsamp); % beta is important. Wn = 0.5
hh = fir1(n,Wn,ftype,kaiser(n+1,beta),'noscale'); % n is order, 

figure;
plot(hh); grid on; title('hh of low');
figure;
freqz(hh)

%% bandpass
fsamp = 2000; % sample freq
fcuts = [200 300 400 500]; % cutoff
mags = [0 1 0]; % bandpass
devs = [0.01 0.01 0.01]; % ripple

[n,Wn,beta,ftype] = kaiserord(fcuts,mags,devs,fsamp); % beta is important
hh = fir1(n,Wn,ftype,kaiser(n+1,beta),'noscale'); % n is order, 

figure;
plot(hh); grid on; title('hh of bandpass');
figure;
freqz(hh)

