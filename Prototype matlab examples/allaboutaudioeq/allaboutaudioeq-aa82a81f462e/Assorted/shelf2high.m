function [num,den] = shelf2high(G,wc)
%shelf2high.m
% Second order HIGH-frequency shelving filter derived in the review article: 
% V. Valimaki and J. D. Reiss, "All About Audio Equalization: Solutions 
% and Frontiers", Applied Sciences, 2016
%
% INPUTS % OUTPUTS
% 
% G = Gain at high frequencies (linear, not dB)
% wc = crossover frequency (radians)
% num = numerator coefficients b0, b1, and b2
% den = denominator coefficients a0, a1, and a2
%
% Written by Vesa Valimaki, April 7, 2016.
% Modified April 29, 2016.

% Filter coefficients
Omega = tan(wc/2);
a0 = sqrt(G)*Omega^2 + sqrt(2)*Omega*G^(1/4) + 1;  % Normalize by 1/a0
a1 = 2*(sqrt(G)*Omega^2 - 1);
a2 = (sqrt(G)*Omega^2 - sqrt(2)*Omega*G^(1/4) + 1);
b0 = sqrt(G)*(sqrt(G) + sqrt(2)*Omega*G^(1/4) + Omega^2);
b1 = sqrt(G)*(2*(-sqrt(G) + Omega^2));
b2 = sqrt(G)*(sqrt(G) - sqrt(2)*Omega*G^(1/4) + Omega^2);

% Transfer function
den = [a0 a1 a2];
num = [b0 b1 b2];
%figure;freqz(num,den)
