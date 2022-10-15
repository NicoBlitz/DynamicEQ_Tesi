

    function W_inv = mappingfrombarkmat(W,nfft)
    %Constructing inverse mapping matrix W_inv from matrix W for mapping back from bark scale
    %usuage: W_inv=mappingfrombarkmat(Wnfft)
    %argument: W: mapping matrix from function mapping2barkmat
    %nfft: : number of subbands in fft
   nfreqs=nfft;

%ref W_inv= np.dot(np.diag((1.0/np.sum(W,1))**0.5), W[:,0:nfreqs + 1]).T


    
   
   
    W_inv=sum(conj(diag(sum(W,2).^0.5))).*transpose(W);
    
   
  
%     W_inv=sum(C);
  
    end

 
