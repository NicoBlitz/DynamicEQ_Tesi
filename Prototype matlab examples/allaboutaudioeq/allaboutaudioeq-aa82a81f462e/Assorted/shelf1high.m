function [num,den] = shelf1high(G,wc)
%shelf1high.m
% first order HIGH-frequency shelving filter derived in the review article: 
% V. Valimaki and J. D. Reiss, "All About Audio Equalization: Solutions 
% and Frontiers", Applied Sciences, 2016
%
% INPUTS % OUTPUTS
% G = Gain at high frequencies (linear, not dB)
% wc = crossover frequency
% num = numerator coefficients b0 and b1
% den = denominator coefficients a0 and a1
%
% Written by Vesa Valimaki, Nov. 5, 2015.
% Modified by Vesa Valimaki, April 29, 2016.

% Transfer function coefficients
a0 = tan(pi/2-wc/2) + sqrt(G);   % tan -> -tan
a1 = (-tan(pi/2-wc/2) + sqrt(G));  % Inverted, also tan -> -tan
b0 = (G*tan(pi/2-wc/2) + sqrt(G));  % also tan -> -tan
b1 = (-G*tan(pi/2-wc/2) + sqrt(G));  % Inverted, tan -> -tan

% Transfer function
den = [a0 a1];
num = [b0 b1];
%figure(3);clf;freqz(num,den)
