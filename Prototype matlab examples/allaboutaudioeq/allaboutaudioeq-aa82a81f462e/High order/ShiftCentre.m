function [k,z,p]=ShiftCentre(N,wc,k1,z1,p1)
a=(1-tan(wc/2))/(1+tan(wc/2));
k=k1;
for n=1:N, 
    z(n)=(a+z1(n))/(a*z1(n)+1);
    p(n)=(a+p1(n))/(a*p1(n)+1);
    k=k*(a*z1(n)+1)/(a*p1(n)+1);
end