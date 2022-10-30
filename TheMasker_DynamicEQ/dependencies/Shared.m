
fs=44100;  % sampling frequency of audio signal
alpha_exp=1;  %Exponent for non-linear superposition of spreading functions
buffersize=1024;
nfft=buffersize/2;  %number of fft subbands
nfilts=32;  %number of subbands in the bark domain

maxfreq=22000;
minfreq=20;

min_dbFS=-96; % minimum dBFS

% fftshift=384;
% fftoverlap=(nfft-fftshift)/2;
% min_power=-2000;

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

% W = mapping2barkmat(fs,nfilts,nfft);
% W_inv = mappingfrombarkmat(W,nfft);

%Absolute threshold in quiet
ATQ_ = ATQ(frequencies).';
ATQ_= db2amp(ATQ_); % convert ATQ (nfft points) to dB
ATQ = (fbank*ATQ_); % decimate ATQ to nfilts points
ATQ = amp2db(ATQ); % convert ATQ (nfilts points) to dB
ATQ = ATQ - (abs(min(ATQ))); % Relocate ATQ so that minimum is at 0


%scale from frquency to Barks
%Based on https://stackoverflow.com/questions/10754549/fft-bin-width-clarification
%512 bins
bin_width = fs / 2 / nfft; 
bins=(0:bin_width:fs/2-1);

for c=1:nfilts
    if(c==1)
        fBandWidths(c)=fCenters(c+1);
    else if(c==nfilts)
            fBandWidths(c)=20000-fCenters(c-1);
        else
        fBandWidths(c)=fCenters(c+1)-fCenters(c-1);
        end
    end
end


