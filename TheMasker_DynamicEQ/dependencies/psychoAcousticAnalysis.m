function threshold = psychoAcousticAnalysis(blockSC_Gain, nfft, fs, fttoverlap)
    %Mono conversion
    blockSC_Gain=mean(blockSC_Gain, 2);
    %Convert to Frequency Domain
    amplitude_ratio_freqs=getFD(blockSC_Gain, fs);

    threshold = amplitude_ratio_freqs;
end