% fig1_low_shelfs.m
%
% Plot examples of low shelving filter responses. 
% This was done for the review article V. Valimaki and J. D. Reiss, 
% "All About Audio Equalization: Solutions and Frontiers", Applied Sciences, 
% 2016
%
% Uses shelf1low.m
%
% Created by Vesa Valimaki, Otaniemi, Espoo, Finland, 6 November 2015
% Modified by Vesa Valimaki, Otaniemi, Espoo, Finland, 29 April 2016

fs = 44100; % Sample rate (Hz)
gvecbd = -12:4:-1; % dB gain values for this example
gvec = 10.^(gvecbd/20); % The same on linear scale
len = length(gvec); % Number of shelving filter pairs
wc = 2*pi*1000/fs; % Crossover frequency in radians
Nfreq = 2048; % Number of frequency points
w = logspace(log10(0.2),log10(22050),Nfreq); % Log frequency scale

figure(1);clf
colors = ['g' 'b' 'r' 'y' 'm' 'c'];
[numcut,dencut] = shelf1low(1,wc); % First design the 0-dB case
H0 = freqz(numcut,dencut,w,fs); % Evaluate frequency response
semilogx(w,db(H0),'k','linewidth',1);hold on % Plot 0 dB line
set(gca,'XTick',[30 100 300 1000 3000 10000]')
set(gca,'YTick',[-12 -10 -8 -6 -4 -2 0 2 4 6 8 10 12]')
axis([20 22000 -13 13])
xlabel('Frequency (Hz)');ylabel('Magnitude (dB)')
set(gca,'fontname','Times','fontsize',16)
plot([1000 1000],[-15 15],'--k','linewidth',1);  % Crossover frequency line
for k = 1:len;
    [numcut,dencut] = shelf1low(gvec(k),wc);  % Low shelf, boost
    [numboost,denboost] = shelf1low(1/gvec(k),wc);  % Low shelf, cut
    Hcut = freqz(numcut,dencut,w,fs); % Evaluate frequency response
    Hboost = freqz(numboost,denboost,w,fs);% Evaluate frequency response
    semilogx(w,db(Hboost),colors(k),'linewidth',2); % Plot on log scale
    semilogx(w,db(Hcut),colors(k),'linewidth',2); % Plot on log scale
end
%print('lowshelf','-dpdf')
