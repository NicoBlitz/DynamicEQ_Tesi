%figs8_9_cascade_geq.m
%
% Design and plot magnitude responses cascade graphic equalizers. The first
% plot is a trivial cascade GEQ illustrating the interference between band
% filters. The second plot has been optimized with the help of a leakage 
% matrix, which accounts for the interference between bands.
% This was done for the review article V. Valimaki and J. D. Reiss, 
% "All About Audio Equalization: Solutions and Frontiers", 
% Applied Sciences, 2016.
%
% Uses peaknotch.m, shelf2low.m, shelf2high.m, compute_leak_factors.m
%
% Written by Vesa Valimaki, Espoo, Finland, 25 November 2015
% Modified by Vesa Valimaki, Espoo, Finland, 29 April 2016

% Parameters
fs  = 44.100;  % Sample rate
fc = [31.5 64 125 250 500 1000 2000 4000 8000 16000]; % ISO center freqs.
wg = 2*pi*fc/fs;  % Command gain frequencies in radians
wc = 2*pi*fc/fs;  % Center frequencies in radians
wc(1) = 2*pi*46/fs;  % Modified crossover frequency for the lowest band
wc(10) = 2*pi*11360/fs;  % Modified crossover freq. for the highest band
bw = 1.*(sqrt(2)- 1/sqrt(2)) * wc;  % Bandwidth (constant Q) in radians

% Commands gains
Gdb = 10*ones(1,10);  % Constant (dB)
G = 10.^(Gdb/20);  % Convert to linear gain factors

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Trivial Cascade Graphic EQ Design
%
% Calculate filter sections
[num1,den1] = shelf2low(G(1),wc(1)); % Low shelving filter
[num2,den2] = peaknotch(G(2),wc(2),bw(2)); % Peak filter
[num3,den3] = peaknotch(G(3),wc(3),bw(3)); % Peak filter
[num4,den4] = peaknotch(G(4),wc(4),bw(4)); % Peak filter
[num5,den5] = peaknotch(G(5),wc(5),bw(5)); % Peak filter
[num6,den6] = peaknotch(G(6),wc(6),bw(6)); % Peak filter
[num7,den7] = peaknotch(G(7),wc(7),bw(7)); % Peak filter
[num8,den8] = peaknotch(G(8),wc(8),bw(8)); % Peak filter
[num9,den9] = peaknotch(G(9),wc(9),bw(9)); % Peak filter
[num10,den10] = shelf2high(G(10),wc(10));  % High shelving filter
%
% Calculate frequency responses
Nfreq = 2048;  % Number of frequency points
w = logspace(log10(0.2),log10(22050),Nfreq);  % Log frequency points
[H1] = freqz(num1,den1,w,fs);
[H2] = freqz(num2,den2,w,fs);
[H3] = freqz(num3,den3,w,fs);
[H4] = freqz(num4,den4,w,fs);
[H5] = freqz(num5,den5,w,fs);
[H6] = freqz(num6,den6,w,fs);
[H7] = freqz(num7,den7,w,fs);
[H8] = freqz(num8,den8,w,fs);
[H9] = freqz(num9,den9,w,fs);
[H10] = freqz(num10,den10,w,fs);
Htot = H1.*H2.*H3.*H4.*H5.*H6.*H7.*H8.*H9.*H10; % Overall freq. response

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Optimized Cascade Graphic EQ Design
%
leak = compute_leak_factors(3.2,wg,wc,bw); % Estimate leakage b/w bands
Goptdb = inv(leak)*Gdb';  % Solve optimal dB gains based on leakage
Gopt = 10.^(Goptdb/20);  % Convert to linear gain factors
%
% Calculate optimized filters 
[numopt1,denopt1] = shelf2low(Gopt(1),wc(1)); % Low shelving filter
[numopt2,denopt2] = peaknotch(Gopt(2),wc(2),bw(2));
[numopt3,denopt3] = peaknotch(Gopt(3),wc(3),bw(3));
[numopt4,denopt4] = peaknotch(Gopt(4),wc(4),bw(4));
[numopt5,denopt5] = peaknotch(Gopt(5),wc(5),bw(5));
[numopt6,denopt6] = peaknotch(Gopt(6),wc(6),bw(6));
[numopt7,denopt7] = peaknotch(Gopt(7),wc(7),bw(7));
[numopt8,denopt8] = peaknotch(Gopt(8),wc(8),bw(8));
[numopt9,denopt9] = peaknotch(Gopt(9),wc(9),bw(9));
[numopt10,denopt10] = shelf2high(Gopt(10),wc(10));  % Low shelving filter
%
% Frequency responses
[Hopt1,f] = freqz(numopt1,denopt1,w,fs);
[Hopt2] = freqz(numopt2,denopt2,w,fs);
[Hopt3] = freqz(numopt3,denopt3,w,fs);
[Hopt4] = freqz(numopt4,denopt4,w,fs);
[Hopt5] = freqz(numopt5,denopt5,w,fs);
[Hopt6] = freqz(numopt6,denopt6,w,fs);
[Hopt7] = freqz(numopt7,denopt7,w,fs);
[Hopt8] = freqz(numopt8,denopt8,w,fs);
[Hopt9] = freqz(numopt9,denopt9,w,fs);
[Hopt10] = freqz(numopt10,denopt10,w,fs);
% Overall frequency response: 
Hopt = Hopt1.*Hopt2.*Hopt3.*Hopt4.*Hopt5.*Hopt6.*Hopt7.*Hopt8.*Hopt9.*Hopt10;

%%%%%%%% FIGURES %%%%%%%%
fontsize = 16;
linewidth = 2; 
figure(1);clf
% Plot responses for the trivial design
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
semilogx(w,db(Htot),'k','linewidth',2.5);  % Total response
plot(fc,Gdb,'ro','linewidth',2)            % Command gains
set(gca,'fontname','Times','fontsize',fontsize)
xlabel('Frequency (Hz)');ylabel('Magnitude (dB)')
set(gca,'XTick',[10 30 100 300 1000 3000 10000]')
%set(gca,'YTick',[-12 -10 -8 -6 -4 -2 0 2 4 6 8 10 12]')
%axis([10 22000 -13.5 13.5])
set(gca,'YTick',[0 2 4 6 8 10 12 14 16 18 20]')
axis([10 22050 min(-1,min(Gdb)-10) max(0,max(Gdb)+6)])

% Compute gain error at center frequencies: 
error_basic = Gdb - db(Htot([893 1015 1136 1258 1380 1503 1625 1747 1870 1991]))

% Plot responses for the optimized design
figure(2);clf
semilogx(w,db(Hopt1),'b','linewidth',linewidth);hold on
semilogx(w,db(Hopt2),'g','linewidth',linewidth);hold on
semilogx(w,db(Hopt3),'r','linewidth',linewidth);hold on
semilogx(w,db(Hopt4),'c','linewidth',linewidth);hold on
semilogx(w,db(Hopt5),'m','linewidth',linewidth);hold on
semilogx(w,db(Hopt6),'b','linewidth',linewidth);hold on
semilogx(w,db(Hopt7),'g','linewidth',linewidth);hold on
semilogx(w,db(Hopt8),'r','linewidth',linewidth);hold on
semilogx(w,db(Hopt9),'c','linewidth',linewidth);hold on
semilogx(w,db(Hopt10),'m','linewidth',linewidth);hold on
semilogx(w,db(Hopt),'k','linewidth',2.5);  % Total response
plot(fc,Gdb,'ro','linewidth',2);           % Command gains
set(gca,'fontname','Times','fontsize',fontsize);
xlabel('Frequency (Hz)');ylabel('Magnitude (dB)')
set(gca,'XTick',[10 30 100 300 1000 3000 10000]')
set(gca,'YTick',[0 2 4 6 8 10 12 14 16 18 20]')
axis([10 22050 min(-1,min(Gdb)-10) max(0,max(Gdb)+6)])

% Compute gain error at center frequencies after optimization: 
error_opt = Gdb - db(Hopt([893 1015 1136 1258 1380 1503 1625 1747 1870 1991]))

% Figure 1: 
%print('casgeq_basic','-dpdf')
% Figure 2: 
%print('casgeq_optim','-dpdf')
