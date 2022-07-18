function mask_fft_magn = maskingThreshold(mX, W, W_inv,fs,spreadingfuncmatrix,alpha_exp,nfft,ATQ_bark_db)

    %Input: magnitude spectrum of a DFT of size 2048
    %Returns: masking threshold (as voltage) for its first 1025 subbands
    %Map magnitude spectrum to 1/3 Bark bands:
    mXbark=mapping2bark(mX,W, nfft);
    %Compute the masking threshold in the Bark domain:
    mTbark=maskingThresholdBark(mXbark,spreadingfuncmatrix,alpha_exp);
    %Map back from the Bark domain,
    %Result is the masking threshold in the linear domain:
    mT=mappingfrombark(mTbark,W_inv,nfft);
    
    %Max between magnitude spectrum of a DFT of size 2048 and threshold in quiet:
    ATQ_bark_magn=10.0.^((ATQ_bark_db-60)/20);
    ATQ_fft=mappingfrombark(ATQ_bark_magn,W_inv,nfft);
    mask_fft_magn=max(mT, ATQ_fft);

    
    end
  

