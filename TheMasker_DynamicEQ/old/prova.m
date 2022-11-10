


sr = 44100;

f = linspace(0,sr/2,100).';

typ = 1;
cf = st2hz(101);
Q = 1 / sqrt(2);
GdB = 6;



types = {'BP1','BP2','LP','HP','NC','AP','PK','LS1','HS1','LS2','HS2'};
[b, a] = getBiquadCoeff(types{typ}, sr, cf, Q, GdB);


[r,rdB] = resp(b,a,f,sr);


semilogx(f,rdB); hold on;
semilogx(cf,GdB,'or'); hold off;
ylim([-30,30]);
xlim([f(2),f(end)]);
grid on;

