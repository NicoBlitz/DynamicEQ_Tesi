%Graphic_abstract.m
%
% Octave parallel graphic equalizer figure, which was used as the
% Graphic Abstract for the review paper:
% V. Valimaki and J. D. Reiss, "All About Audio Equalization: Solutions 
% and Frontiers", Applied Sciences, 2016.
%
% Written by Vesa Valimaki, Espoo, Finland, 25 April 2016
% Modified by Vesa Valimaki, Espoo, Finland, 29 April 2016

fs  = 44.1e3;  % Sample rate
fontsize=14;   % Good font size
%
% Parameters
fc = [31.5 63 125 250 500 1000 2000 4000 8000 16000]; % Std. center freqs.
Gdb = 12*[-1 1 -1 1 -1 1 -1 1 -1 1];  % Zig-zag commands gains (dB)
wc = 2*pi*fc/fs;  % Center frequencies in radians
bw = 1*(sqrt(2)- 1/sqrt(2)) * wc;  % Bandwidth of band filters 
bw(10) = 0.6*bw(10);  % Make the last filter narrow, since it is asymmetric
G = 10.^(Gdb/20);  % Convert to linear gain
%
% Calculate transfer functions for filter sections
[num1,den1] = peaknotch(G(1),wc(1),bw(1));
[num2,den2] = peaknotch(G(2),wc(2),bw(2));
[num3,den3] = peaknotch(G(3),wc(3),bw(3));
[num4,den4] = peaknotch(G(4),wc(4),bw(4));
[num5,den5] = peaknotch(G(5),wc(5),bw(5));
[num6,den6] = peaknotch(G(6),wc(6),bw(6));
[num7,den7] = peaknotch(G(7),wc(7),bw(7));
[num8,den8] = peaknotch(G(8),wc(8),bw(8));
[num9,den9] = peaknotch(G(9),wc(9),bw(9));
[num10,den10] = peaknotch(G(10),wc(10),bw(10));
%
% Calculate frequency responses
Nfreq = 2048;  % Number of frequency points
w = logspace(log10(0.2),log10(22050),Nfreq);  % Log freq scale
[H1,f] = freqz(num1,den1,w,fs);
[H2] = freqz(num2,den2,w,fs);
[H3] = freqz(num3,den3,w,fs);
[H4] = freqz(num4,den4,w,fs);
[H5] = freqz(num5,den5,w,fs);
[H6] = freqz(num6,den6,w,fs);
[H7] = freqz(num7,den7,w,fs);
[H8] = freqz(num8,den8,w,fs);
[H9] = freqz(num9,den9,w,fs);
[H10] = freqz(num10,den10,w,fs);
%
% Overall frequency response for a cascade structure
Htot = H1.*H2.*H3.*H4.*H5.*H6.*H7.*H8.*H9.*H10;

figure(1);clf
linewidth = 1.5; 
semilogx(w,db(H1),'b','linewidth',linewidth);hold on
semilogx(w,db(H2),'g','linewidth',linewidth);
semilogx(w,db(H3),'r','linewidth',linewidth);
semilogx(w,db(H4),'c','linewidth',linewidth);
semilogx(w,db(H5),'m','linewidth',linewidth);
semilogx(w,db(H6),'b','linewidth',linewidth);
semilogx(w,db(H7),'g','linewidth',linewidth);
semilogx(w,db(H8),'r','linewidth',linewidth);
semilogx(w,db(H9),'c','linewidth',linewidth);
semilogx(w,db(H10),'m','linewidth',linewidth);
semilogx(w,db(Htot),'k','linewidth',2.5);
plot(fc,Gdb,'ro','linewidth',2)
set(gca,'fontname','Times','fontsize',fontsize)
xlabel('Frequency (Hz)');ylabel('Magnitude (dB)')
title('Graphic Equalizer')
set(gca,'XTick',[30 100 300 1000 3000 10000]')
axis([10 22000 min(Gdb)-3 max(Gdb)+3])
fig = gcf;
fig.PaperUnits = 'centimeters';
fig.PaperPosition = [0 0 11 9];
fig.PaperPositionMode = 'manual';
% print('GrAbs1','-dpng','-r0')
