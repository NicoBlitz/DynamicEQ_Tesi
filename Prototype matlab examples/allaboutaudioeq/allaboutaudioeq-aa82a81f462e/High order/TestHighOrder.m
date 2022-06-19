clear;
% format: Filters(N,filtertype,G,wc,B,Gb), where N is order, or order/2
% when bandwidth needed (bandpass, bandstop, peaking, notch, out of band
% shelf)
wc=pi/4;
Gb=sqrt(0.5);

[b a z p k]=Filters(1,'PN',2,wc,pi/8,sqrt(2.5));
[h1, w1] = freqz(fliplr(b), fliplr(a),2048);% fliplr used because freqz works on powers of z^-1
figure(1);
zplane(z',p');

[b a z p k]=Filters(4,'PN',2,wc,pi/8,sqrt(2.5));
[h2, w2] = freqz(fliplr(b), fliplr(a),2048);% fliplr used because freqz works on powers of z^-1
figure(2);
zplane(z',p');


figure(3);
hold on;
plot(w1/pi,abs(h1).*abs(h1),'-.');
plot(w2/pi,abs(h2).*abs(h2));
xlabel('Normalised frequency (x\pi rad/sample)');
ylabel('Square magnitude');
ylim([.99 4.01]);