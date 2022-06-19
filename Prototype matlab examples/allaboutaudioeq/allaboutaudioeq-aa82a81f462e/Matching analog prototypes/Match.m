function Match(wc)%try 0.75 as input
wc=wc*pi;
figure(1);
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
h3= freqs(num,den,w);

plot(w/pi,abs(h1).*abs(h1),w/pi,abs(h2).*abs(h2),w/pi,abs(h3).*abs(h3));
xlabel('Normalised frequency (x\pi rad/sample)');
ylabel('Square magnitude');
%plot(x,y1,'-ro',x,y2,'-.b')
legend('Bilinear transform','Analog-matched transform','Analog prototype');

