function wetSignal = dynamicEqualization(blockIN_Gain, threshold, fbank, fs, fCenters)

    %separation switch (-1 or 1)
    %TODO: Bring in Shared
    SEP = 1;

    %prepare input signal: FFT, Barks and amp2dB conversion
    inputSignal = prepareInputSignal(blockIN_Gain, fbank, fs);

    %TEST: higher value for more interesting delta
    threshold = threshold + 10;
    %getting delta
    deltaSignal = getDelta(inputSignal, threshold);

    %UI separation switch
    deltaSignal = deltaSignal*SEP;

    %apply delta on inputSignal (exp/comp)
    processedSignal = processSignal(inputSignal, deltaSignal);
    
    %EQs
    reconstructedSignal = peakFilterEq(processedSignal);


    %---------------------------------------------------------------------
    wetSignal = processedSignal;


end