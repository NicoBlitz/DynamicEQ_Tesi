

function delta_modulated = modulateDelta(delta_raw, parameters, maxGainModule)
    
    % Invert delta according to UIseparation (invert if false)
    if (parameters.sep==false) 
    delta_raw=delta_raw*(-1);
    end

    delta_mono=mean(delta_raw,2);
    delta(:,1)=parameters.stereolink*delta_mono+(1-parameters.stereolink)*delta_raw(:,1); % StereoLinked modulation L
    delta(:,2)=parameters.stereolink*delta_mono+(1-parameters.stereolink)*delta_raw(:,2); %StereoLinked modulation R

    delta(delta>=0)=delta(delta>=0)*parameters.exp;   % Multiply positive deltas by UIexpAmount
    delta(delta<0)=delta(delta<0)*parameters.comp; % Multiply negative deltas by UIcompAmount
    
    delta(delta>maxGainModule)=maxGainModule; % clips deltas over +20 dB
    delta(delta<-maxGainModule)=-maxGainModule; % clips deltas below -20 dB

    delta_modulated=delta*parameters.mix; % Multiply by UImix
end








 