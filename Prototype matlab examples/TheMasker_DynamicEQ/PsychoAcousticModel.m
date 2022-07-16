% variables
Common;
fs=32000  % sampling frequency of audio signal
maxfreq=fs/2
alpha=0.8  %Exponent for non-linear superposition of spreading functions
nfilts=64  %number of subbands in the bark domain
nfft=2048  %number of fft subbands


function spreadingfunctionBarkdB = f_SP_dB(maxfreq,nfilts)
    %usage: spreadingfunctionmatdB=f_SP_dB(maxfreq,nfilts)
    %computes the spreading function protoype, in the Bark scale.
    %Arguments: maxfreq: half the sampling freqency
    %nfilts: Number of subbands in the Bark domain, for instance 64   
    
    maxbark=hz2bark(maxfreq) %upper end of our Bark scale:22 Bark at 16 kHz
    
    %Number of our Bark scale bands over this range: nfilts=64
    spreadingfunctionBarkdB=zeros(2*nfilts)
   
    %Spreading function prototype, "nfilts" bands for lower slope 
    spreadingfunctionBarkdB(1:nfilts)=linspace(-maxbark*27,-8,nfilts)-23.5
   
    %"nfilts" bands for upper slope:
    spreadingfunctionBarkdB(nfilts+1:2*nfilts)=linspace(0,-maxbark*12.0,nfilts)-23.5
    


function spreadingfuncmatrix = spreadingfunctionmat(spreadingfunctionBarkdB,alpha,nfilts)
    %Turns the spreading prototype function into a matrix of shifted versions.
    %Convert from dB to "voltage" and include alpha exponent
    %nfilts: Number of subbands in the Bark domain, for instance 64  
    spreadingfunctionBarkVoltage=10.0^(spreadingfunctionBarkdB/20.0*alpha)
    
    %Spreading functions for all bark scale bands in a matrix:
    spreadingfuncmatrix=zeros(nfilts,nfilts)
    
    for k = 1:nfilts
        spreadingfuncmatrix(k,:)=spreadingfunctionBarkVoltage((nfilts-k):(2*nfilts-k))
    end
     

function mTbark = maskingThresholdBark(mXbark,spreadingfuncmatrix,alpha,fs,nfilts) 
    %Computes the masking threshold on the Bark scale with non-linear superposition
    %usage: mTbark=maskingThresholdBark(mXbark,spreadingfuncmatrix,alpha)
    %Arg: mXbark: magnitude of FFT spectrum, on the Bark scale
    %spreadingfuncmatrix: spreading function matrix from function spreadingfunctionmat
    %alpha: exponent for non-linear superposition (eg. 0.6), 
    %fs: sampling freq., nfilts: number of Bark subbands
    %nfilts: Number of subbands in the Bark domain, for instance 64  
    %Returns: mTbark: the resulting Masking Threshold on the Bark scale 
  
    %Compute the non-linear superposition:
    mTbark=dot(mXbark^alpha, spreadingfuncmatrix^alpha)
  
    %apply the inverse exponent to the result:
    mTbark=mTbark^(1.0/alpha)
  
    %Threshold in quiet:
    maxfreq=fs/2.0
    maxbark=hz2bark(maxfreq)
    step_bark = maxbark/(nfilts-1)
    range_of_filts=(1:nfilts)
    barks=range_of_filts*step_bark
  
    %convert the bark subband frequencies to Hz:
    f=bark2hz(barks)+1e-6
    %Threshold of quiet in the Bark subbands in dB:
    LTQ=np.clip((3.64*(f/1000.)^-0.8 -6.5*np.exp(-0.6*(f/1000.-3.3)^2.)+1e-3*((f/1000.)^4.)),-20,160)
    %Maximum of spreading functions and hearing threshold in quiet:
    mTbark=np.max((mTbark, 10.0^((LTQ-60)/20)),0)
    return     

 hz2bark(f):
    """ Usage: Bark=hz2bark(f)
    f    : (ndarray)    Array containing frequencies in Hz.
    Returns  :
    Brk  : (ndarray)    Array containing Bark scaled values.
    """
    Brk = 6. * np.arcsinh(f/600.)                                                 
    return Brk    

bark2hz(Brk):
    """ Usage:
    Hz=bark2hs(Brk)
    Args     :
        Brk  : (ndarray)    Array containing Bark scaled values.
    Returns  :
        Fhz  : (ndarray)    Array containing frequencies in Hz.
    """
        
    Fhz = 600. * np.sinh(Brk/6.)
    return Fhz

mapping2barkmat(fs, nfilts,nfft):
    %Constructing matrix W which has 1’s for each Bark subband, and 0’s else:
    %nfft=2048; nfilts=64;
    nfreqs=nfft/2
    maxbark=hz2bark(fs/2) %upper end of our Bark scale:22 Bark at 16 kHz
    nfreqs=nfft/2
    step_barks = maxbark/(nfilts-1)
    %the linspace produces an array with the fft band edges:
    binbarks = hz2bark(np.linspace(0,(nfft//2),(nfft//2)+1)*fs//nfft)
    W = np.zeros((nfilts, nfft))
    for i in range(nfilts):
        W[i,0:(nfft//2)+1] = (np.round(binbarks/step_barks)== i)
    return W

mapping2bark(mX,W,nfft):
    %Maps (warps) magnitude spectrum vector mX from DFT to the Bark scale
    %arguments: mX: magnitude spectrum from fft
    %W: mapping matrix from function mapping2barkmat
    %nfft: : number of subbands in fft
    %returns: mXbark, magnitude mapped to the Bark scale
    
    nfreqs=int(nfft/2)
    
    %Here is the actual mapping, suming up powers and conv. back to Voltages:
    mXbark = (np.dot( np.abs(mX[:nfreqs])^2.0, W[:, :nfreqs].T))^(0.5)
    
    return mXbark

mappingfrombarkmat(W,nfft):
    %Constructing inverse mapping matrix W_inv from matrix W for mapping back from bark scale
    %usuage: W_inv=mappingfrombarkmat(Wnfft)
    %argument: W: mapping matrix from function mapping2barkmat
    %nfft: : number of subbands in fft
    nfreqs=int(nfft/2)
    W_inv= np.dot(np.diag((1.0/np.sum(W,1))^0.5), W[:,0:nfreqs + 1]).T
    return W_inv

mappingfrombark(mTbark,W_inv,nfft):
    %usage: mT=mappingfrombark(mTbark,W_inv,nfft)
    %Maps (warps) magnitude spectrum vector mTbark in the Bark scale
    % back to the linear scale
    %arguments:
    %mTbark: masking threshold in the Bark domain
    %W_inv : inverse mapping matrix W_inv from matrix W for mapping back from bark scale
    %nfft: : number of subbands in fft
    %returns: mT, masking threshold in the linear scale
  
    nfreqs=int(nfft/2)
    mT = np.dot(mTbark, W_inv[:, :nfreqs].T)
    return mT

function mT = maskingThreshold(mX, W, W_inv,fs,spreadingfuncmatrix,alpha,nfft)
    %Input: magnitude spectrum of a DFT of size 2048
    %Returns: masking threshold (as voltage) for its first 1025 subbands
    %Map magnitude spectrum to 1/3 Bark bands:
    mXbark=mapping2bark(mX,W, nfft);
    %Compute the masking threshold in the Bark domain:
    mTbark=maskingThresholdBark(mXbark,spreadingfuncmatrix,alpha);
    %Map back from the Bark domain,
    %Result is the masking threshold in the linear domain:
    mT=mappingfrombark(mTbark,W_inv,nfft);
    %Threshold in quiet:
    f=linspace(0,fs/2,1025);
    LTQ=3.64*(f./1000)^-0.8 -6.5*exp(-0.6*(f./1000-3.3).^2)+1e-3*((f./1000).^4);
    mT=max(mT, 10.0^((LTQ-60)/20),0);

 disp('Graph.');
   plot(freqs, X(t), f, mT, 'ko');
   xlabel('Frequency'); ylabel('dB'); title('Graph');
   axis([20 20000 0 100]); pause;