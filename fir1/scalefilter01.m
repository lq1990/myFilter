clc; 
b=[11,22,33,44,55]; ff=[0,0.46,0.46,1];L=5;   

if ff(4)==1
        % unity gain at Fs/2
        f0 = 1;
else
        % unity gain at center of first passband
        f0 = mean(ff(3:4));
end
disp(abs( exp(-1i*2*pi*(0:L-1)*(f0/2))*(b.') ))
 b = b / abs( exp(-1i*2*pi*(0:L-1)*(f0/2))*(b.') );
    
disp(b)
    
    