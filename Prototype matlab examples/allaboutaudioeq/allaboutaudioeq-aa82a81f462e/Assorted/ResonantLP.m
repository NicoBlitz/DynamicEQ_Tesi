clear;

figure(1);
Gc_dB=12;
Gc=10^(Gc_dB/20);
wc=pi/2;
OmegaC=tan(wc/2)
b=[OmegaC*OmegaC 2*OmegaC*OmegaC OmegaC*OmegaC]
a=[OmegaC*OmegaC+OmegaC/Gc+1 2*(OmegaC*OmegaC-1) OmegaC*OmegaC-OmegaC/Gc+1]
[h,w]=freqz(fliplr(b), fliplr(a),2048);
plot(w/pi,abs(h).*abs(h));

xlabel('Normalised frequency (x\pi rad/sample)');
ylabel('Magnitude');

figure(2);
   plot(w/pi,20*log10(abs(h)));

xlabel('Normalised frequency (x\pi rad/sample)');
ylabel('Magnitude (dB)');
ylim([-40 20]);