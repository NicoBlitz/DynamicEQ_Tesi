% fig13_matched_analog.m
% First order lowpass filter: comparison of 
% analog prototype, analog-matched transform and bilinear transform
%
% This function produces a figure used in V. Valimaki and J. D. Reiss, 
% "All About Audio Equalization: Solutions and Frontiers", 
% Applied Sciences, 2016.
%
% Written by Josh D. Reiss, Feb. 2016
% Modified by Vesa Valimaki, 1 March 2016

wc=0.75*pi;
figure(1);clf
hold on;
Gc=sqrt(1/2);
alpha=tan(wc/2)/sqrt(1/(Gc*Gc)-1);
b=[alpha alpha];
a=[1+alpha alpha-1];
[h1 w] = freqz(b, a,2048);

g1 = 2/sqrt(4+(2*pi/wc)^2);
gm = max(sqrt(0.5),sqrt(g1));
Ws = tan(wc*sqrt(1-gm^2)/(2*gm)) *sqrt((gm^2-g1^2)*(1-gm^2)) /(1-gm^2);
b0 = Ws+g1;
b1 = Ws-g1;
a0 = Ws+1;
a1 = Ws-1;
b = [b0/a0 b1/a0];
a = [1 a1/a0];
[h2 w] = freqz(b, a,2048);

num = 1; den = [1/wc 1]; 
h3 = freqs(num,den,w);

figure(1);clf
plot(w/pi,abs(h3).*abs(h3),w/pi,abs(h2).*abs(h2),w/pi,abs(h1).*abs(h1),...
    'linewidth',1.5);
xlabel('Normalised frequency (x\pi rad/sample)');
ylabel('Square magnitude');
set(gca,'fontname','Times','fontsize',16)
axis([0 1 0 1.05])
%plot(x,y1,'-ro',x,y2,'-.b')
legend('Analog prototype','Analog-matched transform','Bilinear transform',...
    'Location','south');
%print('matchedanalogplot','-dpdf')

