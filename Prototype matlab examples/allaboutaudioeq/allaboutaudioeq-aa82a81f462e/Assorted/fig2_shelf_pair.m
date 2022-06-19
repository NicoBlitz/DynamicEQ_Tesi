% fig2_shelf_pair.m
%
% Plot examples of low shelving filter responses. 
% This was done for the review article V. Valimaki and J. D. Reiss, 
% "All About Audio Equalization: Solutions and Frontiers", Applied Sciences, 
% 2016
%
% Uses shelf1low.m and shelf1high.m
%
% Created by Vesa Valimaki, Otaniemi, Espoo, Finland, 6 November 2015
% Modified by Vesa Valimaki, Otaniemi, Espoo, Finland, 29 April 2016

fs = 44100; % Sample rate
g = 10.^(12/20); % dB Gain values for this example
fc = 1000; % Crossover frequency
wc = 2*pi*fc/fs; % Center frequency in radians
Nfreq = 2048;  % Number of frequency points
w = logspace(log10(0.2),log10(22050),Nfreq);  % Logarithmic scale

% Compute transfer functions and frequency responses
[numlow,denlow] = shelf1low(g,wc);  % Design low shelf filter
[numhigh,denhigh] = shelf1high(g,wc);  % Design high shelf filter
Hlow = freqz(numlow,denlow,w,fs); % Evaluate frequency response
Hhigh = freqz(numhigh,denhigh,w,fs); % Evaluate frequency response
Htotal = freqz(conv(numlow,numhigh),conv(denlow,denhigh),w,fs); % Cascade

figure(1);clf;subplot(2,1,1)
semilogx(w,db(Hlow),'b','linewidth',2);hold on    % Plot low shelf
semilogx(w,db(Hhigh),'r','linewidth',2);hold on   % Plot high shelf
semilogx(w,db(Htotal),'k','linewidth',2);hold on  % Plot their cascade
set(gca,'XTick',[30 100 300 1000 3000 10000]')    % Frequency points
set(gca,'YTick',[-12 -10 -8 -6 -4 -2 0 2 4 6 8 10 12]') % dB scale
axis([20 20000 -1.5 13.5])                        % Scaling of axes
xlabel('Frequency (Hz)');ylabel('Magnitude (dB)') % Axis lables
set(gca,'fontname','Times','fontsize',16)         % Sufficiently large font
%print('shelfpair','-dpdf')                        % Produce a PDF figure
