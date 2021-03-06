% zz = z, kk = k

clc;clear; 

a = [ -0.188556717737768,-1.55129618906874e-17,-4.39283914173384e-18,2.14135288722813e-18,6.15338736117624e-18;
    -0.590475174378431,0.493735344472049,0.726438408543796,-4.04552587053889e-18,-8.84502252999502e-18;
    -0.847271958009335,-0.726438408543796,0.0423654024540294,-5.80491911301277e-18,-1.26917098005252e-17;
    -2.18936547166903,-1.48358785742050,-2.20028002484541,0.606458378596819,0.770807912859552;
    -4.28818741887291,-2.90582037001494,-4.30956514233628,-0.770807912859552,0.509738249307560];



b= [1.68087302987440;0.835057999850596;1.19822349403521;3.09623034302570;6.06441280576775];

c = [-0.133752984848819,-0.0906355319763876,-0.134419778074767,-0.0107431343312597,-0.00850178636999647];
% d =   0.189155285181084;
d=0;


[zz, pp, kk] = ss2zp(a,b,c,d);


[z,k] = ltipack.sszero(a,b,c,d,[],[     1000000       10000]);

%% sszero diy
n = length(b);
pt = eig(a);                           % target p

AA = [a,b; c,d];
BB0 =  diag([ones(1, n) 0]);
z0 = eig(AA, BB0);
zt = z0(2:end-1);                       % target z

BB1 =  diag([ones(1, n) 1e-8]);
z1 = eig(AA, BB1);
z11 = eig(BB1\AA);

h = d; % markov param
i = 0;
while h == 0
    h = c*a^(i)*b;
    i = i+1;
end

% kt is the first nonzero h
kt = h;                             % target k


%% test
M = [1,2,3; 4,5,6;7,8,7];
N = [1,0,0; 0,1, 0; 0,0,1e-8];
N0 = diag([1,1,0]);
res1=eig(M, N);
res2=eig(N\M);
res_t=eig(M, N0);

[res1, res2, res_t]
