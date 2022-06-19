function [leak] = compute_leak_factors(G,wg,wc,bw);
%compute_leak_factors.m
% 
% Compute the leak factors of a cascade graphic equalizer to account for
% the band interaction when assigning filter gains. 
% V. Valimaki and J. D. Reiss, 
% "All About Audio Equalization: Solutions and Frontiers", 
% Applied Sciences, 2016.
% 
% Input parameters:
% G  = Linear gain at which the leakage is determined
% wg = Command frequencies in radians
% wc = Center frequencies of filters in rad 
% bw = Bandwidth of filters in radiand (1st and last are skipped)
% 
% Output:
% leak = N by N matrix showing how the magnitude responses of the
% band filters leak to the neighboring bands. N is determined from the
% length of the array wc. 
%
% Uses shelf2low.m, shelf2high.m, peaknotch.m
%
% Written by Vesa Valimaki, Espoo, Finland, 12 April 2016
% Modified by Vesa Valimaki, Espoo, Finland, 29 April 2016

N = length(wc);  % The number of filters
leak = zeros(N,N);  % Initialize interaction matrix
Gdb = db(G);  % Convert linear gain factor to dB

% Estimate leak factors of the first filter (second order low shelf filter)
[num1,den1] = shelf2low(G,wc(1)); % Low shelf filter
H = freqz(num1,den1,wg);  % Frequency response at center frequencies
Gain = db(H)/Gdb;  % Normalized interference (Re 1 dB)
leak(1,:) = abs(Gain); % First row of interaction matrix

% Estimate leak factors of the last filter (second order high shelf filter) 
[numN,denN] = shelf2high(G,wc(N));  % High shelf filter
H = freqz(numN,denN,wg);  % Frequency response at center frequencies
Gain = db(H)/Gdb;  % Normalized interference (Re 1 dB)
leak(N,:) = abs(Gain); % Last row of interaction matrix

% Estimate leak factors of peak/notch filters
for k = 2:N-1;  % Band filters
     [num,den] = peaknotch(G,wc(k),bw(k));  % Design band filter
     H = freqz(num,den,wg);  % Evaluate frequency response
     Gain = db(H)/Gdb;  % Normalized interference (Re 1 dB)
     leak(k,:) = abs(Gain);  % Store gain
end
end
