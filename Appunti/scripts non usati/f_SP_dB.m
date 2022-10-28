
function spreadingfunctionBarkdB = f_SP_dB(maxfreq,nfilts)
    %usage: spreadingfunctionmatdB=f_SP_dB(maxfreq,nfilts)
    %computes the spreading function protoype, in the Bark scale.
    %Arguments: maxfreq: half the sampling freqency
    %nfilts: Number of subbands in the Bark domain, for instance 64   
    maxbark=hz2bark(maxfreq); %upper end of our Bark scale:22 Bark at 16 kHz
    %Number of our Bark scale bands over this range: nfilts=64
    spreadingfunctionBarkdB=zeros(1,2*nfilts);
    %Spreading function prototype, "nfilts" bands for lower slope 
    spreadingfunctionBarkdB(1:nfilts)=linspace(-maxbark*27,-8,nfilts)-23.5;
    %"nfilts" bands for upper slope:
    spreadingfunctionBarkdB(nfilts+1:2*nfilts)=linspace(0,-maxbark*12.0,nfilts)-23.5;
end