

function delta_modulated = modulateDelta(delta, parameters, maxGainModule)
    
    % Invert delta according to UIseparation (invert if false)
    if (parameters.sep==false) 
    delta=delta*(-1);
    end

    delta(delta>=0,:)=delta(delta>=0)*parameters.exp;   % Multiply positive deltas by UIexpAmount
    delta(delta<0,:)=delta(delta<0)*parameters.comp; % Multiply negative deltas by UIcompAmount
    
    delta(delta>maxGainModule)=maxGainModule; % clips deltas over +20 dB
    delta(delta<-maxGainModule)=-maxGainModule; % clips deltas below -20 dB

    delta_modulated=delta*parameters.mix; % Multiply by UImix
end








 