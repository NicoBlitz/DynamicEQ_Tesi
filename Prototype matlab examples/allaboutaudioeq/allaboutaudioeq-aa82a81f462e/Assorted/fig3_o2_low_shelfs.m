% fig1_o2_low_shelfs.m
%
% Plot examples of low shelving filter responses. 
% This was done for the review article V. Valimaki and J. D. Reiss, 
% "All About Audio Equalization: Solutions and Frontiers", Applied Sciences, 
% 2016
%
% Uses shelf2low.m
%
% Created by Vesa Valimaki, Otaniemi, Espoo, 6 November 2015
% Modified by Vesa Valimaki, Otaniemi, Espoo, 29 April 2016

fs = 44100;
gvecbd = -12:4:-1; % dB Gain values for this example
gvec = 10.^(gvecbd/20); % The same on linear scale
len = length(gvec); 
fc = 1000;
wc = 2*pi*fc/fs; % Let's do this for the center frequency of 1 kHz
Nfreq = 2048;  % Number of frequency points
w = logspace(log10(0.2),log10(22050),Nfreq);

figure(2);clf
colors = ['g' 'b' 'r' 'y' 'm' 'c'];
[numcut,dencut] = shelf2low(1,wc); % First design the 0-dB case
H0 = freqz(numcut,dencut,w,fs);    % Evaluate frequency response
semilogx(w,db(H0),'k','linewidth',2);hold on % Plot 0 dB line
set(gca,'XTick',[30 100 300 1000 3000 10000]')
set(gca,'YTick',[-12 -10 -8 -6 -4 -2 0 2 4 6 8 10 12]')
axis([20 22000 -13 13])
xlabel('Frequency (Hz)');ylabel('Magnitude (dB)')
set(gca,'fontname','Times','fontsize',16)
plot([fc fc],[-15 15],'--k','linewidth',1) % Crossover frequency line
for k = 1:len;
    [numcut,dencut] = shelf2low(gvec(k),wc);  % Boost
    [numboost,denboost] = shelf2low(1/gvec(k),wc);  % Cut
    Hcut = freqz(numcut,dencut,w,fs);
    Hboost = freqz(numboost,denboost,w,fs);
    semilogx(w,db(Hboost),colors(k),'linewidth',2);
    semilogx(w,db(Hcut),['--',colors(k)],'linewidth',2); 
end
%print('lowshelf2','-dpdf')
