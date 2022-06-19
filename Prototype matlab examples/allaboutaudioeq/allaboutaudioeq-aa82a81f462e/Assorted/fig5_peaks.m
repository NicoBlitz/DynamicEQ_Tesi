% fig5_peaks.m
%
% Plot a few examples of peaking and notch filter responses. 
% This was done for the review article V. Valimaki and J. D. Reiss, 
% "All About Audio Equalization: Solutions and Frontiers", 
% Applied Sciences, 2016.
%
% Uses peaknotch.m
%
% Written by Vesa Valimaki, Espoo, Finland, 25 November 2015
% Modified by Vesa Valimaki, Espoo, Finland, 29 April 2016

fs = 44100; % Sample rate
gvecdb = [4 12 8]; % dB gain values for this example
gvec = 10.^(gvecdb/20); % The same on the linear scale
len = length(gvec); % Number of cases
wc = [100 1000 10000].*(2*pi/fs); % Center frequencies
B = [100 1000 10000].*(2*pi/fs);  % Bandwidths
Nfreq = 2048;  % Number of frequency points
w = logspace(log10(0.2),log10(22050),Nfreq);  % Log frequency scale

figure(1);clf
colors = ['g' 'b' 'r'];
for k = 1:len;
    [numboost,denboost] = peaknotch(gvec(k),wc(k),B(k));  % Peak filter
    [numcut,dencut] = peaknotch(1/gvec(k),wc(k),B(k));    % Notch filter
    Hboost = freqz(numboost,denboost,w,fs);
    Hcut = freqz(numcut,dencut,w,fs);
    semilogx(w,db(Hboost),colors(k),'linewidth',2);hold on
    semilogx(w,db(Hcut),colors(k),'linewidth',2); hold on
    xlabel('Frequency (Hz)');ylabel('Magnitude (dB)')
    set(gca,'fontname','Times','fontsize',16)
end
set(gca,'XTick',[30 100 300 1000 3000 10000]')
set(gca,'YTick',[-12 -10 -8 -6 -4 -2 0 2 4 6 8 10 12]')
axis([20 22000 -13 13])
%print('peaks','-dpdf')
