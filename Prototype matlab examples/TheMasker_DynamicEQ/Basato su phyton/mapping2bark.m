
function mXbark = mapping2bark(mX,W,nfft)
    %Maps (warps) magnitude spectrum vector mX from DFT to the Bark scale
    %arguments: mX: magnitude spectrum from fft
    %W: mapping matrix from function mapping2barkmat
    %nfft: : number of subbands in fft
    %returns: mXbark, magnitude mapped to the Bark scale
    nfreqs=int(nfft/2);
    %Here is the actual mapping, suming up powers and conv. back to Voltages:
    mXbark = dot(abs(mX(nfreqs))^2.0, W(:, 1:nfreqs).'^(0.5)); %??
end