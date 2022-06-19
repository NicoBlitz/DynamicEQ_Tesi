clear;

figure(2);
hold on;
for m=1:7, 
    G=2^(m-4);
    Gb=sqrt(G);
    [b a z p k]=Filters(2,'LS',G,pi/2,pi/4,Gb);
    [h(:,m), w] = freqz(fliplr(b), fliplr(a),2048);% fliplr used because freqz works on powers of z^-1
    plot(w/pi,20*log10(abs(h(:,m))));
end
xlabel('Normalised frequency (x\pi rad/sample)');
ylabel('Magnitude (dB)');

figure(3);
hold on;
for m=1:7, 
    G=2^(m-4);
    Gb=sqrt(G);
    [b a z p k]=Filters(2,'HS',G,pi/2,pi/4,Gb);
    [h(:,m), w] = freqz(fliplr(b), fliplr(a),2048);% fliplr used because freqz works on powers of z^-1
    plot(w/pi,20*log10(abs(h(:,m))));
end
xlabel('Normalised frequency (x\pi rad/sample)');
ylabel('Magnitude (dB)');

figure(4);
hold on;
for m=1:7, 
    G=2^(m-4);
    Gb=sqrt(G);
    [b a z p k]=Filters(1,'PN',G,pi/2,pi/4,Gb);
    [h(:,m), w] = freqz(fliplr(b), fliplr(a),2048);% fliplr used because freqz works on powers of z^-1
    plot(w/pi,20*log10(abs(h(:,m))));
end
xlabel('Normalised frequency (x\pi rad/sample)');
ylabel('Magnitude (dB)');

%% VARY CUTOFF, CENTRE FREQUENCY
figure(5);
hold on;
for m=1:5, 
    G=2;
    Gb=sqrt(G);
    [b a z p k]=Filters(2,'LS',G,(m-3)*pi/6+pi/2,pi/4,Gb);
    [h(:,m), w] = freqz(fliplr(b), fliplr(a),2048);% fliplr used because freqz works on powers of z^-1
    plot(w/pi,20*log10(abs(h(:,m))));
end
xlabel('Normalised frequency (x\pi rad/sample)');
ylabel('Magnitude (dB)');

figure(6);
hold on;
for m=1:5, 
    G=2;
    Gb=sqrt(G);
    [b a z p k]=Filters(2,'HS',G,(m-3)*pi/6+pi/2,pi/4,Gb);
    [h(:,m), w] = freqz(fliplr(b), fliplr(a),2048);% fliplr used because freqz works on powers of z^-1
    plot(w/pi,20*log10(abs(h(:,m))));
end
xlabel('Normalised frequency (x\pi rad/sample)');
ylabel('Magnitude (dB)');

figure(7);
hold on;
for m=1:5, 
    G=2;
    Gb=sqrt(G);
    [b a z p k]=Filters(1,'PN',G,(m-3)*pi/6+pi/2,pi/4,Gb);
    [h(:,m), w] = freqz(fliplr(b), fliplr(a),2048);% fliplr used because freqz works on powers of z^-1
    plot(w/pi,20*log10(abs(h(:,m))));
end
xlabel('Normalised frequency (x\pi rad/sample)');
ylabel('Magnitude (dB)');

%%VARY BANDWIDTH

figure(8);
hold on;
for m=1:5, 
    G=2;
    Gb=sqrt(G);
    [b a z p k]=Filters(1,'PN',G,pi/2,m*pi/10,Gb);
    [h(:,m), w] = freqz(fliplr(b), fliplr(a),2048);% fliplr used because freqz works on powers of z^-1
    plot(w/pi,20*log10(abs(h(:,m))));
end
xlabel('Normalised frequency (x\pi rad/sample)');
ylabel('Magnitude (dB)');

