function wetSignal = dynamicEqualization(blockIN_Gain, threshold, fbank, fs)

    %prepare input signal: FFT, Barks and amp2dB conversion
    inputSignal = prepareInputSignal(blockIN_Gain, fbank, fs);

    %getting delta
    deltaSignal = getDelta(inputSignal, threshold);

    %---------------------------------------------------------------------
    wetSignal = blockIN_Gain;


end