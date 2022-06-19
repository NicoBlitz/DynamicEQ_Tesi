function [k,z,p]=InverseResponse(N,k1,z1,p1)
k=k1;
for n=1:N, 
    z(n)=-z1(n);
    p(n)=-p1(n);
end