clear;

figure(2);
    G=0.1;
    Gb=sqrt(G);
    [b1 a1 z1 p1 k1]=Filters(1,'LS',G,pi/8,pi/4,Gb);

 G=.1;
    Gb=sqrt(G);
    [b2 a2 z2 p2 k2]=Filters(1,'HS',G,pi/8,pi/4,Gb);
    
    b=conv(b1,b2);
    a=conv(a1,a2);
    [h, w] = freqz(fliplr(b), fliplr(a),2048);% fliplr used because freqz works on powers of z^-1
    semilogx(w/pi,20*log10(abs(h)));
xlabel('Normalised frequency (x\pi rad/sample)');
ylabel('Magnitude (dB)');
