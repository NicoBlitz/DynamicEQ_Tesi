function wetSignal = dynamicEqualization(blockIN_Gain, threshold, fbank, fs, SEP)

    %prepare input signal: FFT, Barks and amp2dB conversion
    inputSignal = prepareInputSignal(blockIN_Gain, fbank, fs);

    %getting delta
    deltaSignal = getDelta(inputSignal, threshold);

    %UI separation switch
    deltaSignal = deltaSignal*SEP;

    %apply delta on inputSignal (exp/comp)
    processedSignal = processSignal(inputSignal, deltaSignal);
    
    %EQs
    %passiamo il segnale input originario 
    equalizedSignal = peakFilterEq(blockIN_Gain, processedSignal);


    %---------------------------------------------------------------------
    wetSignal = equalizedSignal;


end