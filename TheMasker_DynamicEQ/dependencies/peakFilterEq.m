function reconstructedSignal = peakFilterEq(processedSignal)

    Shared;
    processedSignal = processedSignal + 20;
    
    [A,B] = designParamEQ(2,processedSignal,fCenters,fBandWidths,"Orientation","row");
    reconstructedSignal = processedSignal;

end