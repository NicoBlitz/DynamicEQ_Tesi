%This will generate a 3 band dynamic equalizer, where each band has a low
%shelf, peaking/notch and high shelf filter
clear;
nBands=4;
X_deq=[-60,-41,-40,-26,-25,-16,-15,0];
Z_deq=zeros(128,2*nBands);
figure(1);

[bLS aLS] = Filters('LS',2,pi/8,pi/12,sqrt(2));
[bPN aPN] = Filters('PN',2,pi/4,pi/4,sqrt(2));
[bHS aHS] = Filters('HS',2,3*pi/8,pi/12,sqrt(2));
b=conv(bLS,bPN);b=conv(b,bHS);
a=conv(aLS,aPN);a=conv(a,aHS);
[h w] = freqz(b, a,128);
Z_deq(:,1)=10*log10(abs(h).*abs(h));
Z_deq(:,2)=Z_deq(:,1);
Y_deq=22050*w/pi;

[bLS aLS] = Filters('LS',1.8,pi/14,pi/17,sqrt(1.8));
[bPN aPN] = Filters('PN',1.1,pi/4,pi/6,sqrt(1.1));
[bHS aHS] = Filters('HS',.9,3*pi/10,pi/18,sqrt(.9));
b=conv(bLS,bPN);b=conv(b,bHS);
a=conv(aLS,aPN);a=conv(a,aHS);
[h w] = freqz(b, a,128);
Z_deq(:,3)=10*log10(abs(h).*abs(h));
Z_deq(:,4)=Z_deq(:,3);

[bLS aLS] = Filters('LS',1.5,pi/20,pi/12,sqrt(1.5));
[bPN aPN] = Filters('PN',.8,pi/4,pi/12,sqrt(.8));
[bHS aHS] = Filters('HS',.6,pi/20,pi/25,sqrt(.6));
b=conv(bLS,bPN);b=conv(b,bHS);
a=conv(aLS,aPN);a=conv(a,aHS);
[h w] = freqz(b, a,128);
Z_deq(:,5)=10*log10(abs(h).*abs(h));
Z_deq(:,6)=Z_deq(:,5);

[bLS aLS] = Filters('LS',1.5,pi/20,pi/12,sqrt(1.5));
[bPN aPN] = Filters('PN',5,pi/4,pi/12,sqrt(5));
[bHS aHS] = Filters('HS',.25,pi/32,pi/25,sqrt(.25));
b=conv(bLS,bPN);b=conv(b,bHS);
a=conv(aLS,aPN);a=conv(a,aHS);
[h w] = freqz(b, a,128);
Z_deq(:,7)=10*log10(abs(h).*abs(h));
Z_deq(:,8)=Z_deq(:,7);

figure(1)
surf(X_deq,Y_deq,Z_deq);
set(gca, 'YScale', 'log')

xlabel('Input level (dB)');
ylabel('Frequency (Hz)');
zlabel('Gain (dB)');
