% filter
%   a(1)*y(n) = b(1)*x(n) + b(2)*x(n-1) + ... + b(nb+1)*x(n-nb)
%                         - a(2)*y(n-1) - ... - a(na+1)*y(n-na)

clc;clear;close all;

[b, a]  = butter(2, 10/100*2); 
x = sin(1:20);
res=filter(b, a, x);

% y=[];
% n=1; y(n) = b(1) * x(n);
% n=2; y(n) = b(1) * x(n) + b(2) * x(n-1)                    - a(2)*y(n-1);
% n=3; y(n) = b(1) * x(n) + b(2) * x(n-1) + b(3) * x(n-2)    - a(2)*y(n-1) - a(3) * y(n-2);
% n=4; y(n) = b(1) * x(n) + b(2) * x(n-1) + b(3) * x(n-2)    - a(2)*y(n-1) - a(3) * y(n-2);
% n=5; y(n) = b(1) * x(n) + b(2) * x(n-1) + b(3) * x(n-2)    - a(2)*y(n-1) - a(3) * y(n-2);
% n=6; y(n) = b(1) * x(n) + b(2) * x(n-1) + b(3) * x(n-2)    - a(2)*y(n-1) - a(3) * y(n-2);
% n=7; y(n) = b(1) * x(n) + b(2) * x(n-1) + b(3) * x(n-2)    - a(2)*y(n-1) - a(3) * y(n-2);
% n=8; y(n) = b(1) * x(n) + b(2) * x(n-1) + b(3) * x(n-2)    - a(2)*y(n-1) - a(3) * y(n-2);
% n=9; y(n) = b(1) * x(n) + b(2) * x(n-1) + b(3) * x(n-2)    - a(2)*y(n-1) - a(3) * y(n-2);


%% given b,a,x, compute filtered z
z = zeros(1, length(x));
for n=1:length(x)
    for bi = 1 : min(n, length(b))
        z(n) = z(n) +  b(bi) * x(n-(bi-1));
    end
    for ai = 2 : min(n, length(a))
        z(n) = z(n) - a(ai) * z(n-(ai-1));
    end
end


%% myFilter
y_myfilter = myFilter(b, a, x);


[res', z', y_myfilter']



