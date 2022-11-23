function [equalizedSignal,b_coeff,a_coeff] = peakFilterEq(originalSignal, delta, EQcent, EQband, myFilter, filterOrder, B_old, A_old)
    
    equalizedSignal=originalSignal;
    buffDim=size(originalSignal,1);
    [B,A] = designParamEQ(filterOrder, delta.', EQcent, EQband, "Orientation","column");
    for s=1:buffDim
    w=s/buffDim;
    b_coeff=B*w + B_old*(1-w);
    a_coeff=A*w + A_old*(1-w);
    equalizedSignal(s,1) = myFilter(originalSignal(s,1), b_coeff, a_coeff);
    end
   
    

end
