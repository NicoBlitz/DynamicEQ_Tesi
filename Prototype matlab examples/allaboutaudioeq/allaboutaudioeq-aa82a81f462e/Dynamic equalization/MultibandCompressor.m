Y=[10,199,200,799,800,3999,4000,7999];
nBands=4;
nRows=2*nBands;
for i=1:60, %input level in dB
    X(i)=i-60;
end
Z=zeros(2*nBands,60);
%Threshold, Ratio, Knee width values
T=[-30 -30 -38 -38 -25 -25 0 0];
R=[4 4 2 2 1.5 1.5 1 1];
W=[2 2 3 3 3 3 3 3];

for row=1:nRows,
    for i=1:60, 
        if 2*(X(i)-T(row))>=W(row) %Above knee
            Z(row,i)=(X(i)-T(row))*(1/R(row)-1);
        elseif 2*(X(i)-T(row))<=-W(row) %below knee
            Z(row,i)=0;
        else %In knee. Should never be called if knee is zero.
            Z(row,i)=(1/R(row)-1)*((X(i)-T(row)+W(row)/2)^2/(2*W(row)));
        end
    end
end
figure(2)
surf(X,Y,Z);
set(gca, 'YScale', 'log')
xlabel('Input level (dB)');
ylabel('Frequency (Hz)');
zlabel('Gain (dB)');