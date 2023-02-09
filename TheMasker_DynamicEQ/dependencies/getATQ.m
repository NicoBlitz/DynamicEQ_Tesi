

function ATQ = getATQ(f)
  
    clipMinimum=-20;
    clipMaximum=160;
   
   
    %Threshold of quiet in the Bark subbands in dB:
    %absThresh=3.64*(f./1000).^-0.8-6.5*exp(-0.6*(f./1000-3.3).^2)+.001*(f./1000).^4;   % original function
    absThresh=3.64*(f./1000).^-0.8-6.5*exp(-0.6*(f./1000-3.3).^2)+.00015*(f./1000).^4; % edited function (reduces the threshold in high freqs)

   
    %Clip
    absThresh(absThresh>=clipMaximum) =  clipMaximum;
    absThresh(absThresh<=clipMinimum) = clipMinimum;
    ATQ = absThresh.';
    ATQ = ATQ - (abs(min(ATQ))); % Relocate ATQ so that minimum is at 0


end








 