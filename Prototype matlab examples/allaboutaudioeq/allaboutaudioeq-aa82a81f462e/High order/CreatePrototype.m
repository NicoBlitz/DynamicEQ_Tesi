function [k,z,p]=CreatePrototype(N)
%Generate Nth order low pass
k=2^(-N);
for n=1:N, 
    z(n)=-1;
    alpha=((2*n-1)/N-1)*pi/4;
    p(n) = 1i*tan(alpha);
    k=k/cos(alpha);
end