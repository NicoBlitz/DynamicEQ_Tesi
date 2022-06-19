function [num,den] = peaknotch(G,wc,B)
%peaknotch.m
%
% Peak/notch filter design based for the article
% V. Valimaki and J. D. Reiss, "All About Audio Equalization: Solutions 
% and Frontiers", Applied Sciences, 2016.
% The bandwidth is defined as the frequency difference between 
% points at which a gain of G/2 dB occurs (midpoint gain). 
%
% INPUTS AND OUTPUTS
% G = gain at center frequency (linear, not dB)
% wc = center frequency (radians)
% B = bandwidth (radians)
% num = numerator coefficients b0, b1, b2
% den = denominator coefficients a0, a1, a2
%
% Written by Vesa Valimaki, Nov. 25, 2015.
% Modified by Vesa Valimaki, April 29, 2016.

% Transfer function coefficients
a0 = sqrt(G) + tan(B/2);
b0 = sqrt(G) + G*tan(B/2);
b1 = -2*sqrt(G)*cos(wc);
b2 = sqrt(G) - G*tan(B/2);
a1 = -2*sqrt(G)*cos(wc);
a2 = sqrt(G) - tan(B/2);

% Transfer function
num = [b0 b1 b2];
den = [a0 a1 a2];
%figure(1);freqz(num,den,2048,44100)
