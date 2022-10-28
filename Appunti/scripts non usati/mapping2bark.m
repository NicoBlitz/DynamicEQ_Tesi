
function mXbark = mapping2bark(mX,W,nfft)
    %Maps (warps) magnitude spectrum vector mX from DFT to the Bark scale
    %arguments: mX: magnitude spectrum from fft
    %W: mapping matrix from function mapping2barkmat
    %nfft: : number of subbands in fft
    %returns: mXbark, magnitude mapped to the Bark scale
    nfreqs=nfft;
    %Here is the actual mapping, suming up powers and conv. back to Voltages:
    mXbark = sum(conj(abs(mX(1:nfreqs).^2.0)).*transpose(W(:, 1:nfreqs)).^(0.5)); %??
%     plot(mXbark)
end