

function delta_modulated = modulateDelta(delta, parameters)
    
    % Invert delta according to UIseparation (invert if false)
    if (parameters.sep==false) 
    delta=delta*(-1);
    end
    % Multiply positive deltas by UIexpAmount and negative ones by UIcompAmount
    delta(delta>=0,:)=delta(delta>=0)*parameters.exp;
    delta(delta<0,:)=delta(delta<0)*parameters.comp;
    % Multiply by UImix
    delta_modulated=delta*parameters.mix;

end








 