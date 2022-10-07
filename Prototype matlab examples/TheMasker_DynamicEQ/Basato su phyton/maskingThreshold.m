function MT_OUT = maskingThreshold(X, W, W_inv,fs,spreadingfuncmatrix,alpha_exp,nfft,ATQ_bark_db, barks, frequencies)

    %Input: magnitude spectrum of a DFT of size 2048
    %Returns: masking threshold (as voltage) for its first 1025 subbands
    %Map magnitude spectrum to 1/3 Bark bands:
    
    plotIt((1:length(X)),X,'uniform', 'magnitude');
    plotIt(frequencies,ATQ_bark_db,'log', 'log');

    Xbark=mapping2bark(X,W, nfft);
    %Compute the masking threshold in the Bark domain:
%     plotIt(Xbark,'barks','dB','X in barks');

    mTbark=maskingThresholdBark(Xbark,spreadingfuncmatrix,alpha_exp);
%     plotIt(barks,mTbark,'barks', 'dB')

    %Map back from the Bark domain,
    %Result is the masking threshold in the linear (uniform) domain:
    mT=mappingfrombark(mTbark,W_inv,nfft);
    

    %ATQ processing from bark/db to FFT/magn
    ATQ_bark_magn=10.0.^((ATQ_bark_db-60)/20);
    ATQ_fft=mappingfrombark(ATQ_bark_magn,W_inv,nfft);
    
    %Max between magnitude spectrum of a FFT of size nfft and threshold in quiet:

%    mask_fft_magn=max(mT, ATQ_fft);
    MT_OUT=mT;
    
    end
  

