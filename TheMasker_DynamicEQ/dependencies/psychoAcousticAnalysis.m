function threshold = psychoAcousticAnalysis(blockSC_Gain, fs, fbank, spreadingFunctionMatrix, ATQ)
    
    % Mono conversion
    blockSC_Gain=mean(blockSC_Gain, 2);
    % Get Frequency Domain & decimate (in bark domain)
    amplitude_ratio_barks=fbank*getFD(blockSC_Gain, fs);
    
    % "Spread" the threshold
    relative_threshold=spreadingFunctionMatrix*amplitude_ratio_barks;

    % Comparing with relative and absolute threshold
    threshold = relative_threshold;
    % threshold = max(relative_threshold, ATQ);
    
    % Convert to dB
    threshold = real(amp2db(abs(threshold)));    

end