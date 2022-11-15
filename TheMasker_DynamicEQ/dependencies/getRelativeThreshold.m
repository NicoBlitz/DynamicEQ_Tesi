function relative_threshold = getRelativeThreshold(blockSC_Gain, fs, fbank, spreadingFunctionMatrix)
    
    % Mono conversion
%     blockSC_Gain=mean(blockSC_Gain, 2);
    % Get Frequency Domain & decimate (in bark domain)
    amplitude_ratio_barks=fbank*abs(getFD(blockSC_Gain, fs));
    
    % "Spread" the threshold
    relative_threshold=spreadingFunctionMatrix*amplitude_ratio_barks;

    
    % Convert to dB
    relative_threshold = real(amp2db(relative_threshold));

   

end