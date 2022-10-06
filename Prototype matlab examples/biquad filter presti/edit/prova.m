


sr = 44100;

f = logspace(log10(20),log10(20000),100).';

typ = 7;
%%cf = st2hz(101);
cf = 1000

Q = 4;
GdB = 6;



types = {'BP1','BP2','LP','HP','NC','AP','PK','LS1','HS1','LS2','HS2'};
[b, a] = getBiquadCoeff(types{typ}, sr, cf, Q, GdB);
[r,rdB] = resp(b,a,f,sr);

[b, a] = getBiquadCoeff(types{typ}, sr, 2000, 5, -6);
[r,rdB2] = resp(b,a,f,sr);

rdB=rdB+rdB2;


semilogx(f,rdB); hold on;
semilogx(cf,GdB,'or'); hold off;
ylim([-30,30]);
xlim([f(2),f(end)]);
grid on;

