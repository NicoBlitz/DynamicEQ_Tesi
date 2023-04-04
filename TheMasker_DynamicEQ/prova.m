buffersize=4096;
nfft=buffersize/2;  %number of fft subbands
maxfreq=22000;
minfreq=20; 
maxbark=hz2bark(maxfreq);
minbark=hz2bark(minfreq);
step_bark = (maxbark-minbark)/(nfft-1);
barks=minbark:step_bark:maxbark;
f=bark2hz(barks); % frequency (Hz) array (dimension 1 x nfft)  

y=8.5*(f./1000).^-0.5-6.5*exp(-0.6*(f./1000-3.3).^2)+.57*(f./1000).^1.61; % edited function (reduces the threshold in high freqs)
    clipMinimum=-20;
    clipMaximum=160;
    
   
    %Clip
    y(y>=clipMaximum) =  clipMaximum;
    y(y<=clipMinimum) = clipMinimum;
semilogx(f,y, LineWidth=2);