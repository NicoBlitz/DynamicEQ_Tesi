
function spreadingfuncmatrix = spreadingFunctionMatrix(maxfreq,nfilts,alpha_exp)
     %Arguments: maxfreq: half the sampling frequency
     %nfilts: Number of subbands in the Bark domain, for instance 64
     fadB= 14.5+12; % Simultaneous masking for tones at Bark band 12
     fbdb=7.5; % Upper slope of spreading function
     fbbdb=26.0; % Lower slope of spreading function
     maxbark=hz2bark(maxfreq);
     spreadingfunctionBarkdB= zeros(1, 2*nfilts);
     %upper slope, fbdB attenuation per Bark, over maxbark Bark (full frequency range),
     %with fadB dB simultaneous masking:
     spreadingfunctionBarkdB(1:nfilts)= linspace(-maxbark*fbdb,-2.5,nfilts)-fadB;
     %lower slope fbbdb attenuation per Bark, over maxbark Bark (full frequency range):
     spreadingfunctionBarkdB(nfilts+1:2*nfilts) = linspace(1,-maxbark*fbbdb,nfilts)-fadB;
     %Convert from dB to "voltage" and include a exponent
     spreadingfunctionBarkVoltage=10.0.^(spreadingfunctionBarkdB/20.0*alpha_exp);
     %Spreading functions for all bark scale bands in a matrix:
     spreadingfuncmatrix= zeros(nfilts,nfilts);
     for k =1:nfilts
         spreadingfuncmatrix(:,k) = spreadingfunctionBarkVoltage((nfilts-k+1):(2*nfilts-k));
     end


end
