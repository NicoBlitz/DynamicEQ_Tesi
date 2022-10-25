function threshold = psychoAcousticAnalysis(blockSC_Gain, nfft, fs, fttoverlap, fbank, spreadingFunctionMatrix)
    %Mono conversion
    blockSC_Gain=mean(blockSC_Gain, 2);
    %Convert to Frequency Domain
    % [fbank,cent] = getfbank(frequencies, bandWidthFreq, 'bark', wfunc, nfilts)
    amplitude_ratio_barks=real(fbank*getFD(blockSC_Gain, fs));
    
    dB_barks= amp2db(abs(amplitude_ratio_barks));
    
    spreadedThreshold=spreadingFunctionMatrix*dB_barks;
    %threshold = spreadedThreshold;
    threshold = dB_barks;
end