function mT = mappingfrombark(mTbark,W_inv,nfft)
    %usage: mT=mappingfrombark(mTbark,W_inv,nfft)
    %Maps (warps) magnitude spectrum vector mTbark in the Bark scale
    % back to the linear scale
    %arguments:
    %mTbark: masking threshold in the Bark domain
    %W_inv : inverse mapping matrix W_inv from matrix W for mapping back from bark scale
    %nfft: : number of subbands in fft
    %returns: mT, masking threshold in the linear scale
    nfreqs=int(nfft/2);
    mT = dot(mTbark, W_inv(:, 1:nfreqs).')
end
