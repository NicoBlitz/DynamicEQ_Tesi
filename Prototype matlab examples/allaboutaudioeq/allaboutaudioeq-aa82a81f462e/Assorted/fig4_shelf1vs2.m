% fig4_shelf1vs2.m
%
% Plot comparison of a pari of first order low shelving filter responses 
% again a second order low shelving filter. 
%
% This was done for the review article V. Valimaki and J. D. Reiss, 
% "All About Audio Equalization: Solutions and Frontiers", Applied Sciences, 
% 2016
%
% Uses shelf1low.m and shelf2low.m
%
% Created by Vesa Valimaki, Otaniemi, Espoo, Finland, 4 November 2015
% Modified by Vesa Valimaki, Otaniemi, Espoo, Finland, 7 April 2016

fs = 44100; % Sample rate
g = 10.^(12/20); % dB Gain values for this example
fc = 1000; % Crossover frequency
wc = 2*pi*fc/fs; % Crossover frequency in radians
Nfreq = 2048;  % Number of frequency points
w = logspace(log10(0.2),log10(22050),Nfreq); % logarithmic frequency scale

% Computer transfer functions
[num1,den1] = shelf1low(g,wc); % First order low shelf
[num11,den11] = shelf1low(sqrt(g),wc);  % Gain sqrt(G) for cascaded filters
[num2,den2] = shelf2low(g,wc); % Second order low shelf

% Evaluate frequency responses
H1 = freqz(num1,den1,w,fs); % First order low shelf
H11 = freqz(conv(num11,num11),conv(den11,den11),w,fs); % Cascaded shelfs
H2 = freqz(num2,den2,w,fs); % Second order low shelf

figure(1);clf;subplot(2,1,1)
semilogx(w,db(H11),'r','linewidth',2);hold on
semilogx(w,db(H1),'k--','linewidth',2);hold on
semilogx(w,db(H2),'b','linewidth',2);hold on
set(gca,'XTick',[30 100 300 1000 3000 10000]')
set(gca,'YTick',[-12 -10 -8 -6 -4 -2 0 2 4 6 8 10 12]')
axis([20 20000 -1.5 13.5])
xlabel('Frequency (Hz)');ylabel('Magnitude (dB)')
set(gca,'fontname','Times','fontsize',16)
%print('shelf_1vs2','-dpdf')
