

function ATQ = getATQ(f)
  
    %Min & max range of dB to clip our absThresh 
    % in order to have sensible values
    clipMinimum=-20;
    clipMaximum=160;
   
    %Threshold of quiet in the Bark subbands, in dB:

    % original function (taken from https://colab.research.google.com/github/GuitarsAI/AudioCodingTutorials/blob/master/AC_05_psychoAcousticsModels.ipynb)
    % absThresh=3.64*(f./1000).^-0.8-6.5*exp(-0.6*(f./1000-3.3).^2)+.001*(f./1000).^4;  

    % edited function (reduces the threshold in high freqs)
    absThresh=3.64*(f./1000).^-0.8-6.5*exp(-0.6*(f./1000-3.3).^2)+.00015*(f./1000).^4; 
   
    %Clip
    absThresh(absThresh>=clipMaximum) = clipMaximum;
    absThresh(absThresh<=clipMinimum) = clipMinimum;
    ATQ = absThresh.';
    ATQ = ATQ - ((min(ATQ))); % Relocate ATQ so that minimum is at 0


end








 