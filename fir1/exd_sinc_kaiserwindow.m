clear;clc;
%% exd. 
%         final double[] window = FirwinHelper.createOneTransitionKaiserWindow(
% 0.01,  ripple
% 100,   transition width
% 250,   cutoff      => matlab:  fcuts[250-100/2, 250+100/2]
% 1000,   sample freq
% FilterType.LOWPASS, 
% false);  scale

arr = [-0.0028959917339668635, -0.0048847399293831285, 0.007527670683115644, 0.010980154005078395, -0.015462631804243286,...
    -0.021316608604909474, 0.02912305671611756, 0.03997969451009999, -0.056253969907149017, -0.0841423872273145,...
    0.14646361347730139, 0.4489524178703789, 0.4489524178703789, 0.14646361347730139, -0.0841423872273145,...
    -0.056253969907149017, 0.03997969451009999, 0.02912305671611756, -0.021316608604909474, -0.015462631804243286,...
    0.010980154005078395, 0.007527670683115644, -0.0048847399293831285, -0.0028959917339668635] % #=24

figure;
plot(arr);
grid on;
title('exd sinc*kaiserwindow');

figure;
freqz(arr)
title('exd freqz arr')

%% vs. matlab

fsamp = 1000; % sample freq
fcuts = [200 300]; % cutoff
mags = [1 0]; % lowpass
devs = [0.01 0.01]; % ripple

[n,Wn,beta,ftype] = kaiserord(fcuts,mags,devs,fsamp);
hh = fir1(n,Wn,ftype,kaiser(n+1,beta),'scale');
figure;
freqz(hh)
title('matlab freqz hh')

disp('hh:')
disp(hh)
