

function delta = modulateDelta(delta_raw, parameters, maxGainModule)
    
    delta_mono=mean(delta_raw,2); 
    delta(:,1)=parameters.stereolink*delta_mono+(1-parameters.stereolink)*delta_raw(:,1); % StereoLinked modulation L
    delta(:,2)=parameters.stereolink*delta_mono+(1-parameters.stereolink)*delta_raw(:,2); %StereoLinked modulation R
    
    delta(delta>=0)=delta(delta>=0)*parameters.exp;   % Multiply positive deltas by UIexpAmount
    delta(delta<0)=delta(delta<0)*parameters.comp; % Multiply negative deltas by UIcompAmount

    delta=delta*parameters.mix; % Multiply by UImix

    if(nargin>2)
    delta = tanh(delta/maxGainModule)*maxGainModule; % Delta soft clipping at maxGainModule value
    end
end








 