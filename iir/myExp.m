clc;

w = 2 + 1.96522054313967i;
x = real(w);
y = imag(w);

exp(w)
myexp = exp(x)*(cos(y) + 1i*sin(y));

myexp