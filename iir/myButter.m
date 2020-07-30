function [ num, den ] = myButter( n, Wn, ftype )
    % n: order = filterLength -1
    % Wn: cutoff / (samplefreq / 2)
    % ftype: 1=lowpass, 2=bandpss, 3=highpass, 4=bandstop
    
    % step 1: get analog, pre-warped frequencies
    fs = 2;
    u = 2*fs*tan(pi*Wn/fs);
    
    Bw=[];
    % step 2: convert to low-pass prototype estimate
    if btype == 1	% lowpass
        Wn = u;
    elseif btype == 2	% bandpass
        Bw = u(2) - u(1);
        Wn = sqrt(u(1)*u(2));	% center frequency
    elseif btype == 3	% highpass
        Wn = u;
    elseif btype == 4	% bandstop
        Bw = u(2) - u(1);
        Wn = sqrt(u(1)*u(2));	% center frequency
    end
    
    % step 3: Get N-th order Butterworth analog lowpass prototype
    [z,p,k] = myButtap(n);

    % Transform to state-space
    [a,b,c,d] = myZp2ss(z,p,k);
    

    % return
    den = myPoly(a);
    num = myButtnum(ftype,n,Wn,Bw,0,den);

    
end

