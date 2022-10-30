

function absThresh = ATQ(frequencies)
  
    %convert the bark subband frequencies to Hz:
    clipMinimum=-20;
    clipMaximum=160;
   
    f=frequencies;
    %Threshold of quiet in the Bark subbands in dB:
    absThresh=3.64*(f./1000).^-0.8-6.5*exp(-0.6*(f./1000-3.3).^2)+.001*(f./1000).^4;

   
    %Clip
%     absThresh(absThresh>=clipMaximum) =  clipMaximum;
%     absThresh(absThresh<=clipMinimum) = clipMinimum;

    


end








 