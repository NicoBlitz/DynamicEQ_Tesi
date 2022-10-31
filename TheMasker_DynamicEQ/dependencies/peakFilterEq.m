function equalizedSignal = peakFilterEq(originalSignal, processedSignal)

    Shared;
    processedSignal = processedSignal+20;
    
    [B,A] = designParamEQ(4,processedSignal,EQcent,EQband);
    [bB,aA] = designParamEQ(4,processedSignal,EQcent,EQband,"Orientation","row");
    %fvtool([bB,aA]);
    equalizedSignal = myFilter(originalSignal,B,A);

end
