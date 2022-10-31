function equalizedSignal = peakFilterEq(originalSignal, delta)

    Shared;
    
    [B,A] = designParamEQ(2, delta.', EQcent, EQband, "Orientation","row");
%     fvtool([bB,aA]);
    A_ = A(:,2:3);
    equalizedSignal = myFilter(originalSignal,B.',A_.');

%     equalizedSignal=originalSignal;
%     for i=1:nfilts
%         [B,A] = getBiquadCoeff('PK', fs, fCenters(i), 0.6, delta(i));
%         equalizedSignal = myFilter(equalizedSignal,B.',A(1,2:3).');
% 
%     end

    %     for i=1:4
%     indexMin=(i-1)*nfilts/4 + 1;
%     indexMax=i*nfilts/4;
%     mPEQ = multibandParametricEQ('NumEQBands',nfilts/4,'Frequencies',fCenters(1,indexMin:indexMax), 'PeakGains', delta(indexMin:indexMax,1).', 'SampleRate', fs); 
%     equalizedSignal = mPEQ(equalizedSignal);
%     end

end
