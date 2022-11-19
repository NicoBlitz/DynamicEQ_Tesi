

function delta_modulated = modulateDelta(delta, parameters, maxGainModule, smoothingType)
    
    % Invert delta according to UIseparation (invert if false)
    if (parameters.sep==false) 
    delta=delta*(-1);
    end

    delta(delta>=0,:)=delta(delta>=0)*parameters.exp;   % Multiply positive deltas by UIexpAmount
    delta(delta<0,:)=delta(delta<0)*parameters.comp; % Multiply negative deltas by UIcompAmount

    %partially hardcoded under here :) 
    if(smoothingType=="sigm")
    medianDeltaValue = max(delta)/2;
    delta = (tanh(delta/medianDeltaValue))*medianDeltaValue; % sigmoid to smooth value
    end
    
    if(smoothingType=="sech")
    delta = delta .* sech((delta/10).^2);
    end


    delta_modulated=delta*parameters.mix; % Multiply by UImix
end








 