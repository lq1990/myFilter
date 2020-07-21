Fs = 500;
N = 500;
rng default

xn = ecg(N)+0.25*randn([1 N]);
tn = (0:N-1)/Fs;
nfilt = 70;
Fst = 75;

d = designfilt('lowpassfir','FilterOrder',nfilt, ...
               'CutoffFrequency',Fst,'SampleRate',Fs);


xf = filter(d,xn);

plot(tn,xn)
hold on, plot(tn,xf,'-r','linewidth',1.5), hold off
title 'Electrocardiogram'
xlabel 'Time (s)', legend('Original Signal','Filtered Signal')