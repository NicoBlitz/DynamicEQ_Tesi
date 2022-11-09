
fs=44100;  % sampling frequency of audio signal
buffersize=1024;
nfft=buffersize/2;  %number of fft subbands
nfilts=32;  %number of subbands in the bark domain
nyquistFreq = fs/2; 

maxfreq=22000;
minfreq=20;



%frequencies and barks
maxbark=hz2bark(maxfreq);
minbark=hz2bark(minfreq);
step_bark = (maxbark-minbark)/(nfft-1);
barks=minbark:step_bark:maxbark;
frequencies=bark2hz(barks);
frequencyNumbers = linspace(1,nfilts,nfilts);



[ fbank, cent ] = getfbank( frequencies, 'auto', 'bark', @triang, nfilts );
fCenters=bark2hz(cent);

octaves=(hz2st(maxfreq)-hz2st(minfreq))/12;
bw_oct=octaves/nfilts;



% Spreading function
%Exponent for non-linear superposition of spreading functions: 
% the higher the value -> the lower the threshold, the higher the amount of "spreading"
alpha_exp=0.5;  
spreadingfunctionmatrix = spreadingFunctionMatrix(maxfreq, nfilts, alpha_exp);

%Absolute threshold in quiet
min_dbFS=-96; % minimum dBFS (used by ATQ)
ATQ_lift=1.25; % scales the ATQ: the higher the value, the higher the threshold in quiet

% PeakEQFilter variables
myFilter = dsp.BiquadFilter( ...
    SOSMatrixSource="Input port", ...
    ScaleValuesInputPort=false);
filterOrder = 2;
Q=sqrt(2^(bw_oct))/(2^bw_oct-1);

EQcent=fCenters/nyquistFreq;
EQband=zeros(1,nfilts);

for i=1:nfilts  
    EQband(i)=EQcent(i)/Q;
end

%Plot syle variables
wetStr = '#00a36d';
wetColor = sscanf(wetStr(2:end),'%2x%2x%2x',[1 3])/255;

%{ 
PROVA CAMBIO FREQUENZE

% [ doubleFBank, doubleCent ] = getfbank( frequencies, 'auto', 'bark', @triang, 2*nfilts );
% doubleFCenters=bark2hz(doubleCent);
% fCrossover=zeros(1,nfilts);
% for i=1:(nfilts-1)*2
%     if mod(i,2)==1
%         fCrossover(ceil(i/2))=bark2hz(doubleCent(i+2));
%     end
% end
% fCrossover(nfilts)=maxfreq;

% oct_bw=zeros(1,nfilts);
% Q=zeros(1,nfilts);
% st_bw=zeros(1,nfilts);
% fInf=zeros(1,nfilts);
% fSup=zeros(1,nfilts);

%Band Widths calculation
% fBandWidths=zeros(1,nfilts);
% fBandWidths(1)=(fCenters(1)-minfreq)*2;
% for c=2:nfilts-1
%    fBandWidths(c)=(fCenters(c)-(fCenters(c-1)+fBandWidths(c-1)/2))*2;
% end
% fBandWidths(nfilts)=(fCenters(nfilts)-(fCenters(nfilts-1)+fBandWidths(nfilts-1)/2))+(maxfreq-fCenters(nfilts-1));

% for i=1:nfilts
%     if (i==1)
%         fInf(i)=minfreq;
%         fSup(i)=fCenters(i)+(fCenters(i)-fInf(i));
%         st_bw(i)=hz2st(fCrossover(i),minfreq,0);
% 
%     elseif (i==nfilts)
%         fInf(i)=fSup(i-1);
%         fSup(i)=maxfreq;
%     else
%         fInf(i)=fSup(i-1);
%         fSup(i)=fCenters(i)+(fCenters(i)-fInf(i));
%         st_bw(i)=hz2st(fCrossover(i),fCrossover(i-1),0);
% 
%     end  
% end

%}





