[n,Wn,beta,ftype] = kaiserord([1500 2000],... % cutoff
    [1 0],... % mags
    [0.01 0.1],... % ripple
    8000); % sampleFreq

% kaiserord()的参数不同，可以生成 low/high/band

b = fir1(n,Wn,ftype,kaiser(n+1,beta),'scale'); % kaiser()只是一个window。

c = kaiserord([1500 2000],[1 0],[0.01 0.1],8000,'cell');
bcell = fir1(c{:});

figure;
subplot(211)
plot(b); grid on ; title('b');
subplot(212)
plot(bcell); grid on; title('bcell');

return

hfvt = fvtool(b,1,bcell,1);
legend(hfvt,'b','bcell')

