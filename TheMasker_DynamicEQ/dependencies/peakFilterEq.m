function [equalizedSignal,B,A] = peakFilterEq(originalSignal, delta, EQcent, EQband, myFilter, filterOrder)

    
    [B,A] = designParamEQ(filterOrder, delta.', EQcent, EQband, 'sos', "Orientation","column");
    equalizedSignal = myFilter(originalSignal,B,A);

end
