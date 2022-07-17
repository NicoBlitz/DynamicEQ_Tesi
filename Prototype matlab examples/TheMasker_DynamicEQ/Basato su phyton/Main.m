clear;

Shared;
function launch()  

persistent readerSC
 readerSC = dsp.AudioFileReader('Filename','..\audio\Explainer_Video_Clock_Alarm_Buzz_Timer_5.wav', ...
       'PlayCount',Inf,'SamplesPerFrame',nfft*2);


 y = getMaskingThreshold(readerSC);


plottalo(x,y);


   
end