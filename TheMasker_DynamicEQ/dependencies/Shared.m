
fs=44100;  % sampling frequency of audio signal
alpha_exp=0.8;  %Exponent for non-linear superposition of spreading functions
buffersize=1024;
nfft=buffersize/2;  %number of fft subbands
nfilts=32;  %number of subbands in the bark domain <3
%fftshift=384;
%fftoverlap=(nfft-fftshift)/2;

maxfreq=22000;
minfreq=20;
min_power=-2000;



% frequencies=linspace(minfreq,maxfreq,nfft/2);
maxbark=hz2bark(maxfreq);
minbark=hz2bark(minfreq);
step_bark = (maxbark-minbark)/(nfft-1);
barks=minbark:step_bark:maxbark;
frequencies=bark2hz(barks);
bandWidthFreq=zeros(length(frequencies));
for i=1:length(frequencies)
    if(i==length(frequencies)) 
    bandWidthFreq(i)=0;
    else
    bandWidthFreq(i)=frequencies(i+1)-frequencies(i);
    end
end

[ fbank, cent ] = getfbank( frequencies, 'auto', 'bark', @triang, nfilts );
fCenters=bark2hz(cent);
spreadingfunctionmatrix = spreadingFunctionMatrix(maxfreq, nfilts, alpha_exp);

W = mapping2barkmat(fs,nfilts,nfft);
W_inv = mappingfrombarkmat(W,nfft);

%Absolute threshold in quiet
ATQ_ = ATQ(frequencies).';
ATQ = fbank*ATQ_;

ATQ = 10.^((ATQ-60)/20);
ATQ = amp2db(ATQ);

%{
figure;
ATQplot = plot(linspace(1,length(ATQ),length(ATQ)), ATQ, 'red');
xlabel('frequency number');
ylabel('dBSPL');
legend('ATQ','Location','best','Orientation','vertical')
title('Absolute threshold in quiet - still not mapped');
%}

%scale from frquency to Barks
%Based on https://stackoverflow.com/questions/10754549/fft-bin-width-clarification
%512 bins
bin_width = fs / 2 / nfft; 
bins=(0:bin_width:fs/2-1);

for c=1:nfilts
    if(c==1)
        fBandWidths(c)=fCenters(c+1)-minfreq;
    else if(c==nfilts)
            fBandWidths(c)=maxfreq-fCenters(c-1);
        else
        fBandWidths(c)=fCenters(c+1)-fCenters(c-1);
        end
    end
end

myFilter = dsp.BiquadFilter( ...
    SOSMatrixSource="Input port", ...
    ScaleValuesInputPort=false);

%separation switch (-1 or 1)
SEP = 1;


%normalized for EQ
%BRUTTO! probabilmente da scalare
maxFCent = fCenters(nfilts); 
for c=1:nfilts
    EQcent(c)=fCenters(c)/maxFCent;
end

for c=1:nfilts
    if(c==1)
        EQband(c)=EQcent(c+1)-EQcent(c)/2;
    else if(c==nfilts)
            EQband(c)=1-EQcent(c-1);
        else
        EQband(c)=EQcent(c+1)-EQcent(c-1);
        end
    end
end

