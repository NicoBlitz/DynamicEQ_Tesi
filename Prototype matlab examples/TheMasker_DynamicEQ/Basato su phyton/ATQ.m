

function absThresh = ATQ(frequencies)

    
    
  
  
    %convert the bark subband frequencies to Hz:
    
   
    f=frequencies;
    %Threshold of quiet in the Bark subbands in dB:
    absThresh=3.64*(f./1000).^-0.8-6.5*exp(-0.6*(f./1000-3.3).^2)+.001*(f./1000).^4;
    %Clip
    absThresh(absThresh>160) = 160;
    absThresh(absThresh<-20) = -20;
    
% semilogx(barks, absThresh, barks, absThresh, 'ko');
%    %semilogx(f, TH(:,ATH), '-r', 'LineWidth', 2);
% 
%  xlabel('Barks '); ylabel('?'); title('Absolute threshold in quiet.');
%   axis([min(barks) max(barks) min(absThresh) max(absThresh)]); %pause;

end








 