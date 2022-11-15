

function delta = modulateDelta(delta_raw, parameters, maxGainModule)
    
    delta_mono=mean(delta_raw,2); 
    delta(:,1)=parameters.stereolink*delta_mono+(1-parameters.stereolink)*delta_raw(:,1); % StereoLinked modulation L
    delta(:,2)=parameters.stereolink*delta_mono+(1-parameters.stereolink)*delta_raw(:,2); %StereoLinked modulation R
    
    delta(delta>=0)=delta(delta>=0)*parameters.exp;   % Multiply positive deltas by UIexpAmount
    delta(delta<0)=delta(delta<0)*parameters.comp; % Multiply negative deltas by UIcompAmount
    
    % sigmoide che fa da gater al delta(alle singole bande?)


      % giù, per ultimo


    delta=delta*parameters.mix; % Multiply by UImix
    delta(delta>maxGainModule)=maxGainModule; % clips deltas over +20 dB
    delta(delta<-maxGainModule)=-maxGainModule; % clips deltas below -20 dB
end








 