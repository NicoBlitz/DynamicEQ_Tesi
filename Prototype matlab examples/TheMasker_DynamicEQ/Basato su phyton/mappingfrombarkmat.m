

    function W_inv = mappingfrombarkmat(W,nfft)
    %Constructing inverse mapping matrix W_inv from matrix W for mapping back from bark scale
    %usuage: W_inv=mappingfrombarkmat(Wnfft)
    %argument: W: mapping matrix from function mapping2barkmat
    %nfft: : number of subbands in fft
    nfreqs=int(nfft/2);
    W_inv= dot(diag((1.0/sum(W,1))^0.5), W(:,0:nfreqs + 1).');
    end

 
