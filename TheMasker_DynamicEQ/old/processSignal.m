function processedSignal = processSignal(inputSignal, deltaSignal)

    %TODO: Bring in Shared
    ExpAmount = 1;
    CompAmount = 1;

    %Exp/Comp depending on delta
    %TODO: handle attack and release? maybe not on Matlab :)
    for band=1:length(deltaSignal)
        d = deltaSignal(band);
        in = inputSignal(band);
        if(d>0)
            in = in + d * ExpAmount;
        end
        if(d<0)
            in = in + d * CompAmount;
        end
        processedSignal(band) = in;
    end
    
    


end