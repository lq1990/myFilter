clc;

w = 3 + 1.96522054313967i;
a = real(w);
b = imag(w);

log(w)
mylog = log(a*a + b*b) / 2 + atan(b/a)*1i; % acos

mylog