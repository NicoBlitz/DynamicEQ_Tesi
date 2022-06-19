% pargeq_figures.m
%
% Design and plot magnitude responses parallel octave graphic equalizers. 
% This function produces two figure used in V. Valimaki and J. D. Reiss, 
% "All About Audio Equalization: Solutions and Frontiers", 
% Applied Sciences, 2016.
%
% The parallel graphic equalizer design is based on the paper: 
% J. Rämö, B. Bank, and V. Välimäki, “High-precision parallel graphic 
% equalizer,” IEEE/ACM Trans. Audio, Speech, and Language Processing, 
% vol. 22, no. 12, pp. 1894-1904, Dec. 2014.
%
% NOTE:
% Uses functions parfiltfresp.m, freqpoles.m, minphasen.m, parfiltfresp.m
% written by Balazs Bank. Please download these functions from: 
% http://research.spa.aalto.fi/publications/papers/ieee-taslp-pge/
% Otherwise you cannot run this script!!!
%
% Written by Vesa Valimaki, Espoo, Finland, 12 December 2015
% Modified by Vesa Valimaki, Espoo, Finland, 29 April 2015

fs  = 44.1e3;  % Sample rate
FSTART=20;      % Lowest band
FSTOP=20000;    % Highest band

% ISO octave center freqs.
eqfr = [31.5 63 125 250 500 1000 2000 4000 8000 16000]; 
BANDS = length(eqfr);  % Number of bands
eqfr=[0 eqfr fs/2]; % Add extra points to prevent interpolation errors

% Set command gains
eqgain0 = 10*ones(1,10);
eqgain0(5:8) = -10;
eqgain0(2) = -10;
eqgain = [eqgain0(1) eqgain0 eqgain0(end)];  % Add two extra points
fir = 1; % Parallel direct path b_0 is in use

% Create target response using cubic Hermite interpolation
lowestp = 20;
targetfr=logspace(log10(lowestp),log10(fs/2),BANDS*10);
dBtarget=pchip(eqfr,eqgain,targetfr);
wtarget=2*pi*targetfr/fs;

% Poles are first set to their nomical frequencies with extra poles b/w
% each command frequency
polefr = zeros(1,19); % 10 poles at octave frequencies + 9 extra poles
polefr(1:2:end) = [31.5 63 125 250 500 1000 2000 4000 8000 16000];
for k = 2:2:19
    polefr(k) = sqrt(polefr(k-1)*polefr(k+1));  % Geometric mean freqs
end
p = freqpoles([lowestp polefr]); % Compute poles (function by B. Bank)
POLENUM = length(polefr); % Number of poles

% Use two times more points for optimization than there are pole freqs
designfr = logspace(log10(lowestp),log10(fs/2),POLENUM*2);  % Log freqs
wdesign = 2*pi*designfr/fs;  % Design frequencies in radians

% Convert the target response to minimum-phase, resample at design freqs
minphtarget = minphasen(10.^(dBtarget/20),wtarget,2^14,wdesign);
Wt = 1./abs(minphtarget).^2; % Frequency-dependent weighting function

% Design second-order sections [Bm,Am] and the FIR coefficient b_0
[Bm,Am,FIR] = parfiltdesfr(wdesign,minphtarget,p,fir,Wt);

% Evaluate frequency response
Nfreq = 2048;  % Number of frequency points
wfr = logspace(log10(0.1),log10(22050),Nfreq);  % Log frequencies (Hz)
w = pi*wfr/(fs/2);  % Log freq points in radians
parfresp = parfiltfresp(Bm,Am,FIR,w);  % Evaluate frequency response
eqgain_fc = eqgain(2:end-1); % Command gains

%%%%%%%% FIGURES 
fontsize = 16;
linewidth = 2;
%
% Plot parallel EQ
figure(1);clf
semilogx(wfr,db(parfresp),'k','LineWidth',linewidth);hold on;
semilogx(eqfr(2:end-1),eqgain_fc,'ro','linewidth',2,'markersize',8);
hold off;xlim([10 22050]);grid off;
set(gca,'XTick',[10 30 100 300 1000 3000 10000]')
xlabel('Frequency (Hz)');ylabel('Magnitude (dB)')
set(gca,'fontname','Times','fontsize',fontsize)
%print('pargeq_optim','-dpdf')

% Compute band filter frequency responses
[H1] = freqz(Bm(:,1),Am(:,1),wfr,fs);
[H2] = freqz(Bm(:,2),Am(:,2),wfr,fs);
[H3] = freqz(Bm(:,3),Am(:,3),wfr,fs);
[H4] = freqz(Bm(:,4),Am(:,4),wfr,fs);
[H5] = freqz(Bm(:,5),Am(:,5),wfr,fs);
[H6] = freqz(Bm(:,6),Am(:,6),wfr,fs);
[H7] = freqz(Bm(:,7),Am(:,7),wfr,fs);
[H8] = freqz(Bm(:,8),Am(:,8),wfr,fs);
[H9] = freqz(Bm(:,9),Am(:,9),wfr,fs);
[H10] = freqz(Bm(:,10),Am(:,10),wfr,fs);
[H11] = freqz(Bm(:,11),Am(:,11),wfr,fs);
[H12] = freqz(Bm(:,12),Am(:,12),wfr,fs);
[H13] = freqz(Bm(:,13),Am(:,13),wfr,fs);
[H14] = freqz(Bm(:,14),Am(:,14),wfr,fs);
[H15] = freqz(Bm(:,15),Am(:,15),wfr,fs);
[H16] = freqz(Bm(:,16),Am(:,16),wfr,fs);
[H17] = freqz(Bm(:,17),Am(:,17),wfr,fs);
[H18] = freqz(Bm(:,18),Am(:,18),wfr,fs);
[H19] = freqz(Bm(:,19),Am(:,19),wfr,fs);
[H20] = freqz(Bm(:,20),Am(:,20),wfr,fs);

figure(2);clf
semilogx(wfr,db(H20),'g--','linewidth',linewidth);hold on
semilogx(wfr,db(FIR)*ones(size(wfr)),'g:','linewidth',linewidth);
semilogx(wfr,db(H1),'b-','linewidth',linewidth);
semilogx(wfr,db(H2),'r--','linewidth',linewidth);
semilogx(wfr,db(H3),'b-','linewidth',linewidth);
semilogx(wfr,db(H4),'r--','linewidth',linewidth);
semilogx(wfr,db(H5),'b-','linewidth',linewidth);
semilogx(wfr,db(H6),'r--','linewidth',linewidth);
semilogx(wfr,db(H7),'b-','linewidth',linewidth);
semilogx(wfr,db(H8),'r--','linewidth',linewidth);
semilogx(wfr,db(H9),'b-','linewidth',linewidth);
semilogx(wfr,db(H10),'r--','linewidth',linewidth);
semilogx(wfr,db(H11),'b-','linewidth',linewidth);
semilogx(wfr,db(H12),'r--','linewidth',linewidth);
semilogx(wfr,db(H13),'b-','linewidth',linewidth);
semilogx(wfr,db(H14),'r--','linewidth',linewidth);
semilogx(wfr,db(H15),'b-','linewidth',linewidth);
semilogx(wfr,db(H16),'r--','linewidth',linewidth);
semilogx(wfr,db(H17),'b-','linewidth',linewidth);
semilogx(wfr,db(H18),'r--','linewidth',linewidth);
semilogx(wfr,db(H19),'b-','linewidth',linewidth);
axis([10 22050 -50 10]);grid off;
set(gca,'XTick',[10 30 100 300 1000 3000 10000]')
xlabel('Frequency (Hz)')
ylabel('Magnitude (dB)')
set(gca,'fontname','Times','fontsize',fontsize)
%print('pargeq_subfilters','-dpdf')
