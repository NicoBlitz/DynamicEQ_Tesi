function [k,z,p]=CreateBandpass(N,wc,k1,z1,p1)
k=k1;
a=cos(wc);
for n=1:N, 
    z(2*n-1)=a*(1+z1(n))/2+sqrt(a*a*(1+z1(n))*(1+z1(n))-4*z1(n))/2;
    z(2*n)=a*(1+z1(n))/2-sqrt(a*a*(1+z1(n))*(1+z1(n))-4*z1(n))/2;
    p(2*n-1)=a*(1+p1(n))/2+sqrt(a*a*(1+p1(n))*(1+p1(n))-4*p1(n))/2;
    p(2*n)=a*(1+p1(n))/2-sqrt(a*a*(1+p1(n))*(1+p1(n))-4*p1(n))/2;
 end
