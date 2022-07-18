
fs=44100;  % sampling frequency of audio signal
alpha_exp=0.8;  %Exponent for non-linear superposition of spreading functions
nfilts=32;  %number of subbands in the bark domain
nfft=512;  %number of fft subbands
fftshift=384;
fftoverlap=(nfft-fftshift)/2;
buffersize=nfft;
maxfreq=fs/2;
minfreq=20;
min_power=-2000;
frequencies=linspace(minfreq,maxfreq,nfft/2);
maxbark=hz2bark(maxfreq);
minbark=hz2bark(minfreq);
step_bark = maxbark/(nfilts-1);
barks=(1:nfilts)*step_bark;

W = mapping2barkmat(fs,nfilts,nfft);
spreadingfuncmatrix = spreadingFunctionMat(maxfreq,nfilts,alpha_exp);
ATQ_current=ATQ(barks);
W_inv = mappingfrombarkmat(W,nfft);

% function W = mapping2barkmat(fs, nfilts,nfft)
%     %Constructing matrix W which has 1’s for each Bark subband, and 0’s else:
%     %nfft=2048; nfilts=64;
%     nfrequencies=nfft/2;
%     maxbark=hz2bark(fs/2); %upper end of our Bark scale:22 Bark at 16 kHz
%     nfrequencies=nfft/2;
%     step_barks = maxbark/(nfilts-1);
%     %the linspace produces an array with the fft band edges:
%     binbarks = hz2bark(linspace(0,floorDiv(nfft,2),floorDiv(nfft,2)+1)*floorDiv(fs,nfft));
%     W = zeros(nfilts, nfft);
%         for i = 1:nfilts
%             W(i,0:floorDiv(nfft,2)+1) = round(binbarks/step_barks)== i; %??
%         end
%     end


