
    function W = mapping2barkmat(fs, nfilts,nfft)
    %Constructing matrix W which has 1’s for each Bark subband, and 0’s else:
    %nfft=2048; nfilts=64;
    nfreqs=nfft/2;
    maxbark=hz2bark(fs/2); %upper end of our Bark scale:22 Bark at 16 kHz
    nfreqs=nfft/2;
    step_barks = maxbark/(nfilts-1);
    %the linspace produces an array with the fft band edges:
    binbarks = hz2bark(linspace(0,floorDiv(nfft,2),floorDiv(nfft,2)+1)*floorDiv(fs,nfft));
    W = zeros(nfilts, nfft);
        for i = 1:nfilts
            W(i,1:floorDiv(nfft,2)+1) = round(binbarks/step_barks)== i; %??
        end
    end
 