function equalizedSignal = peakFilterEq(originalSignal, processedSignal)

    Shared;
    processedSignal = processedSignal;
    
    [B,A] = designParamEQ(32,processedSignal,fCenters,fBandWidths);
    equalizedSignal = myFilter(originalSignal,B,A);

end
