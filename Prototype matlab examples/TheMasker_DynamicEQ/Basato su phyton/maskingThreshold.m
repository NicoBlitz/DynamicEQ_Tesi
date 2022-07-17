function mT = maskingThreshold(mX, W, W_inv,fs,spreadingfuncmatrix,alpha,nfft)

    %Input: magnitude spectrum of a DFT of size 2048
    %Returns: masking threshold (as voltage) for its first 1025 subbands
    %Map magnitude spectrum to 1/3 Bark bands:
    mXbark=mapping2bark(mX,W, nfft)
    %Compute the masking threshold in the Bark domain:
    mTbark=maskingThresholdBark(mXbark,spreadingfuncmatrix,alpha)
    %Map back from the Bark domain,
    %Result is the masking threshold in the linear domain:
    mT=mappingfrombark(mTbark,W_inv,nfft)
    
    %Threshold in quiet:
    [LTQ,barks,f] = LTQ.AbsThresh(fs,nfilts);

    %f=np.linspace(0,fs/2,1025)
    %LTQ=np.clip((3.64*(f/1000.)^-0.8 -6.5*np.exp(-0.6*(f/1000.-3.3)**2.)+1e-3*((f/1000.)**4.)),-20,80)
    mT=max(mT, 10.0^((LTQ-60)/20));
    end
  

