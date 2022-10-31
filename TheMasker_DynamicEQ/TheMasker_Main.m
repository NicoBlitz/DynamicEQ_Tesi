
%TODOS
%migliorare exp e comp
%capire output
%ordinare dati su shared (mergiare da psycho)

close all;
clear;

% Add audio and dependencies folders to path
folder = fileparts(which(mfilename)); 
addpath(genpath(folder));

% Creates Absolute Threshold in quiet and other constant variables
Shared;

% Read entire files
[input] = audioread("audio\Michael Buble edit.wav");
[scInput] = audioread("audio\Michael Buble edit.wav");



% input signals truncation at "endSample"th sample
endSample= 20000; %take just first x samples

% (if "endSample" is greater than the original duration (in samples),
% "endSample" will be overrided with original duration);
endSample=min(endSample,length(input));

input=input(1:endSample,:);
scInput=scInput(1:endSample,:);



% PREPARE TO PLAY

% signals initialization
duration=length(input);
totBlocks=ceil(duration/buffersize)-1;

sample=linspace(1,duration,duration);
blocks=linspace(1,totBlocks,totBlocks);

threshold = zeros(nfft,1);
thresholdBuffer = zeros(nfilts,totBlocks);
wetSignal = zeros(duration,2);

% parameters initialization
UIinGain = 0.8;
UIscGain = 0.8;
UIoutGain = 1.0;

UIcleanUp = 1.0;





%---------------------------------------------------------------------------------
% PROCESS BLOCK 

% Execute algorithm from first to last sample of the file with a step of nfft*2 


ATQ_scaled = ATQ * UIcleanUp; % Scale ATQ according to UI knob "CleanUp"
ATQ_scaled = ATQ_scaled + min_dbFS; % Relocate ATQ so that minimum is at -96 dBFS
ATQ_scaled = min(ATQ_scaled, 0); % Clip (highest values of) ATQ at 0 dB

figure;
blockNumber=1;

for offset = 1:buffersize:length(input)-buffersize



blockEnd = offset+buffersize-1;

blockSC = scInput(offset:blockEnd,:);
blockIN = input(offset:blockEnd,:);   

blockIN_Gain = blockIN * UIinGain;
blockSC_Gain = blockSC * UIscGain;

% Calculate block's threshold depending on our psychoacoustic model  
% nfilts already exist in Shared - where ATQ and spreadingFunction are calculated 
threshold = psychoAcousticAnalysis(blockSC_Gain, fs, fbank, spreadingfunctionmatrix, ATQ_scaled);
thresholdBuffer(:,blockNumber)=threshold;

% Signal processing depending on the threshold just calculated
wetBlock = dynamicEqualization(blockIN_Gain, threshold, fbank, fs, SEP) * UIoutGain;

% Signal reconstruction (current block concatenation)
wetSignal(offset:blockEnd,1)=wetBlock(:,1);
wetSignal(offset:blockEnd,2)=wetBlock(:,2);

blockNumber=blockNumber+1;

end


% Threshold heatmap plot
%{
figure;
thresholdHeatmap = heatmap(real(thresholdBuffer)); %Complex values are not supported.
xlabel('time');
ylabel('frequency number');
title('Threshold over time in dBFS');
%}

% ATQ plot (dBFS vs frequencies)
figure;
ATQplot = semilogx(fCenters, ATQ_scaled, 'red');
xlabel('frequency (Hz)');
ylabel('dBFS');
legend('ATQ','Location','best','Orientation','vertical')
title('Absolute threshold in quiet');

%in vs out in TD plot
%{
figure;
hold on
plot(1:20000, input(:,1), 'blue');
plot(1:20000, wetSignal(:,1), 'red');
title('in vs out');
%}


% Play file
soundsc(wetSignal,fs)

 

