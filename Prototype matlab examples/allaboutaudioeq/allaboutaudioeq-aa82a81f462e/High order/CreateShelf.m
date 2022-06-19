function [k,z,p]=CreateShelf(N,G,k1,z1,p1)
%Generate Nth order  shelving filter from prototype
k=2^(-N);
for n=1:N, 
    g=G^(1/N);
    p(n) = p1(n);
    z(n)=(1+p(n)-g*(1-p(n)))/(1+p(n)+g*(1-p(n)));
    k=k*(1+p(n)+g*(1-p(n)));
end