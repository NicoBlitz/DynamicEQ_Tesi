function relative_threshold = getRelativeThreshold(blockSC_Gain, fs, fbank, spreadingFunctionMatrix)
    numChannels=size(blockSC_Gain,2);
    for ch=1:numChannels
        % Get Frequency Domain & decimate (in bark domain)
        blockSC_Gain(:,ch)=blockSC_Gain(:,ch).*hann(size(blockSC_Gain, 1));
        amplitude_ratio_barks(:,ch)=fbank*abs(getFD(blockSC_Gain(:,ch), fs));
        
        % "Spread" the threshold
        relative_threshold(:,ch)=spreadingFunctionMatrix*amplitude_ratio_barks(:,ch);
    
        
        % Convert to dB
        relative_threshold(:,ch) = real(amp2db(relative_threshold(:,ch)));
    
    end  

end