clc;
w = 2 + 1.96522054313967i;
re = real(w);
im = imag(w);
acos(w)
res = (-1i) * log( w + (1i) * sqrt(1 - w * w) ); % acos

res