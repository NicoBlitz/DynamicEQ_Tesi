function wetSignal = dynamicEqualization(blockIN_Gain, threshold, nfft, fs, nfilts, frequencies)

    %prepare input signal: FFT, Barks and amp2dB conversion
    inputSignal = prepareInputSignal(blockIN_Gain, nfft, fs, nfilts, frequencies);

    %getting delta
    %deltaSignal = getDelta(inputSignal, threshold);

    %---------------------------------------------------------------------
    wetSignal = blockIN_Gain;


end