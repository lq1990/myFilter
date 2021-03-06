% user given
width = 0.1; % width ratio = transistionWidth/sampleFreq
wn = [0.2, 0.5]; % wn = cutoff/(sampleFreq/2)
ripple = 0.01; % 

% compute
fsamp = 2000; % sample freq
transistionWidth = width*fsamp;
fcuts = [wn*(fsamp/2)-transistionWidth/2, wn*(fsamp/2) + transistionWidth/2]; % cutoff
fcuts = [fcuts(1), fcuts(3), fcuts(2), fcuts(4)];
% mags = [1 0]; % low
% mags = [0 1]; % high
mags = [0 1 0]; % pass
% mags = [1 0 1]; % stop
devs = [ripple, ripple, ripple]; % ripple

[n,Wn,beta,ftype] = kaiserord(fcuts,mags,devs,fsamp); % n is orer
hh = fir1(n,Wn,ftype,kaiser(n+1,beta), 'scale'); % default scale


%  fir1(24, [0.2, 0.5], 'bandpass', kaiser(25, 3.395321)) % bandpass
%  fir1(24, [0.2, 0.5], 'stop', kaiser(25, 3.395321)) % bandstop

freqz(hh)


% exd
%         window = new KaiserWindow(0.1, 0.01, FilterType.LOW, true); //
%         width=transistionWidth/sampleFreq, ripple,ftype, scale
%         outcome = WindowFirBuilder.build(window, 0.5); // 0.5 is wn = cutoff/(sampleFreq/2)

%% kaiserord design in exd
