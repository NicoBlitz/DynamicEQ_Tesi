function [num,den] = shelf2low(G,wc)
%shelf2low
% Second- rder low shelving filter based on the design based on the
% review paper: 
% V. Valimaki and J. D. Reiss, "All About Audio Equalization: Solutions 
% and Frontiers", Applied Sciences, 2016.
%
% INPUTS % OUTPUTS
%
% G = Gain at low frequencies (linear, not dB)
% wc = crossover frequency (radians)
% num = numerator coefficients b0, b1, and b2
% den = denominator coefficients a0=1, a1, and a2
%
% Written by Vesa Valimaki, 7 April 2016
% Modified by Vesa Valimaki, 29 April 2016

% Filter coefficients
Omega = tan(wc/2);
a0 = sqrt(1/G)*Omega^2 + sqrt(2)*Omega*G^(-1/4) + 1;
a1 = 2*(sqrt(1/G)*Omega^2 - 1);
a2 = sqrt(1/G)*Omega^2 - sqrt(2)*Omega*G^(-1/4) + 1;
b0 = sqrt(G)*Omega^2 + sqrt(2)*Omega*G^(1/4) + 1;
b1 = 2*(sqrt(G)*Omega^2 - 1);
b2 = sqrt(G)*Omega^2 - sqrt(2)*Omega*G^(1/4) + 1;

% Transfer function
den = [a0 a1 a2];
num = [b0 b1 b2];
%figure;freqz(num,den)
