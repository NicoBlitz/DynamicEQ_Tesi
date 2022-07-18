
function mT = getMaskingThreshold(mX,offset) 
Shared;

	    [X,Delta] = FFT_Analysis(mX,offset);
        mT = maskingThreshold(X, W, W_inv,fs,spreadingfuncmatrix,alpha,nfft);
end



