clear;
wc=pi/4;
B=pi/4;
G=2;
Gc=sqrt((G*G+1)/2);
Gc=sqrt(G);

figure(1);%Low shelf
[bLS aLS] = Filters('LS',2,pi/8,B,sqrt(2));
[h w] = freqz(bLS, aLS,2048);
plot(w/pi,10*log10(abs(h).*abs(h)));
xlabel('Normalised frequency (x\pi rad/sample)');
ylabel('Magnitude (dB)');

figure(3);%High shelf
[bHS aHS] = Filters('HS',2,3*pi/8,B,sqrt(2));
[h w] = freqz(bHS, aHS,2048);
plot(w/pi,10*log10(abs(h).*abs(h)));
xlabel('Normalised frequency (x\pi rad/sample)');
ylabel('Magnitude (dB)');

figure(5);%Peak Notch
[b a] = Filters('PN',3,pi/4,pi/4,sqrt(3));
[h w] = freqz(b, a,2048);
plot(w/pi,10*log10(abs(h).*abs(h)));
xlabel('Normalised frequency (x\pi rad/sample)');
ylabel('Magnitude (dB)');

%Now plot a graphic eq from 3 filters
[bLS aLS] = Filters('LS',2,pi/8,B,sqrt(2));
[bPN aPN] = Filters('PN',2,pi/4,pi/4,sqrt(2));
[bHS aHS] = Filters('HS',2,3*pi/8,B,sqrt(2));

b=conv(bLS,bPN);
a=conv(aLS,aPN);
b=conv(b,bHS);
a=conv(a,aHS);
figure(6);%Peak Notch
[h w] = freqz(b, a,2048);
plot(w/pi,10*log10(abs(h).*abs(h)));
xlabel('Normalised frequency (x\pi rad/sample)');
ylabel('Magnitude (dB)');

