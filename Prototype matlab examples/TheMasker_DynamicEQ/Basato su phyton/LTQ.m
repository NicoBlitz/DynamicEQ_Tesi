% variables
%
classdef LTQ
methods (Static)
Shared;
function Brk = hz2bark(f)
%      Usage: Bark=hz2bark(f)
%     f    : (ndarray)    Array containing frequencies in Hz.
%     Returns  :
%     Brk  : (ndarray)    Array containing Bark scaled values.
%     
 
Brk = 6.*asinh(f./600)                                                
end

function FHz = bark2hz(Brk)
 Fhz = 600.* sinh(Brk/6.)
end


function [absThresh,barks] = AbsThresh(fs,nfilts)

    maxfreq=fs/2.0;
    maxbark=hz2bark(maxfreq);
    step_bark = maxbark/(nfilts-1);
    barks=(0:nfilts)*step_bark;
  
    %convert the bark subband frequencies to Hz:
    f=bark2hz(barks)+1e-6;

    %Threshold of quiet in the Bark subbands in dB:
    absThresh=3.64*(f./1000).^-0.8-6.5*exp(-0.6*(f./1000-3.3).^2)+.001*(f./1000).^4;
    %Clip
    absThresh(absThresh>160) = 160;
    absThresh(absThresh<-20) = -20;
     
semilogx(barks, absThresh, barks, absThresh, 'ko');
   %semilogx(f, TH(:,ATH), '-r', 'LineWidth', 2);

   xlabel('Barks '); ylabel('?'); title('Absolute threshold in quiet.');
   axis([min(barks) max(barks) min(absThresh) max(absThresh)]); %pause;





    end

 end

end






 