
close all;
clear;

% Add audio and dependencies folders to path
folder = fileparts(which(mfilename)); 
addpath(genpath(folder));

% Creates constant variables
Shared;

% Read entire files
[input] = audioread("audio\Michael Buble edit.wav");
[scInput] = audioread("audio\Michael Buble edit.wav");
% [scInput] = audioread("audio\Explainer_Video_Clock_Alarm_Buzz_Timer_5.wav");

duration=length(input);
totBlocks=ceil(duration/buffersize)-1;
sample=linspace(1,duration,duration);
blocks=linspace(1,totBlocks,totBlocks);

% input signals truncation at "endSample"th sample
endSample= min(20000,length(input)); %take just first x samples, if x < input length

input=input(1:endSample,:);
scInput=scInput(1:endSample,:);


% PREPARE TO PLAY

% signals initialization
threshold = zeros(nfft,1);
thresholdBuffer = zeros(nfilts,totBlocks);
wetSignal = zeros(duration,2);

% parameters initialization
UIinGain = 0.9;
UIscGain = 0.9;
UIoutGain = 1.0;
UI_atq_weight = 1.0;
UIseparation = 1;

%---------------------------------------------------------------------------------
% PROCESS BLOCK 
% Execute algorithm from first to last sample of the file with a step of nfft*2 
ATQ_decimated = ATQ(frequencies, fbank);
ATQ_scaled = ATQ_decimated * UI_atq_weight * ATQ_lift; % Scale ATQ according to UI knob "CleanUp" and internal value ATQ_lift
ATQ_scaled = ATQ_scaled + min_dbFS; % Lower ATQ so that minimum is at -96 dBFS
ATQ_scaled = min(ATQ_scaled, 0); % Clip (highest values of) ATQ at 0 dB



% Create main plot
figure;


blockNumber=1;

for offset = 1:buffersize:length(input)-buffersize
    
    % Calculate last sample of the block
    blockEnd = offset+buffersize-1;
  
    % Shift among samples and multiply by Input and Sidechain's UI Gain 
    blockIN_Gain = input(offset:blockEnd,:) * UIinGain;
    blockSC_Gain = scInput(offset:blockEnd,:) * UIscGain;
    
    % Calculate block's threshold depending on our psychoacoustic model  
    threshold = psychoAcousticAnalysis(blockSC_Gain, fs, fbank, spreadingfunctionmatrix, ATQ_scaled);
    
    % Prepare input signal: FFT, Barks and amp2dB conversion
    input_Freq_dB = decimateFD(blockIN_Gain, fbank, fs);
    
    % Getting delta
    delta = input_Freq_dB - threshold;
    
    % UI separation switch
    delta_modulated = delta*UIseparation;
    
    % Equalization
    [wetBlock,B,A] = peakFilterEq(blockIN_Gain, delta_modulated, EQcent, EQband, myFilter, filterOrder);
    
    % "Decimation" of the wet Signal to fit in the same plot
    wetBlock_mono = mean(wetBlock,2);
    wetBlock_Freq = fbank*abs(getFD(wetBlock_mono, fs));
    wetBlock_Freq_dB = amp2db(wetBlock_Freq);

    % Calculate effective gain reduction
    gainReduction = wetBlock_Freq_dB - input_Freq_dB;
        
    % Threshold reconstruction (current block concatenation)
    thresholdBuffer(:,blockNumber)=threshold;
    
    % Signal reconstruction (current block concatenation)
    wetSignal(offset:blockEnd,:)= wetBlock * UIoutGain;
    
    DryPlot= amp2db(abs(getFD(mean(blockIN_Gain,2), fs)));
    WetPlot= amp2db(abs(getFD(wetBlock_mono, fs)));
   
 
    % FIRST PLOT:  
    clf('reset');
    subplot(1,2,1);

    % Plot input
    INplot= semilogx(fCenters, input_Freq_dB, 'blue');
    hold on;
    
    % Plot relative and absolute thresholds
    THplot= semilogx(fCenters, threshold, '--black');
    ATQplot = semilogx(fCenters, ATQ_scaled, '--red');
    
    % Plot delta negative and positive.
    deltaPOSplot= bar(fCenters, max(delta_modulated,0), 'g', 'BarWidth', 1);
    deltaNEGplot= bar(fCenters, min(delta_modulated,0), 'm', 'BarWidth', 1);
    
    % Plot wet and gain reduction signal
%     OUTplot= semilogx(fCenters, wetBlock_Freq_dB, 'Color', wetColor);
%     GRplot= semilogx(fCenters, gainReduction, 'red');
    hold off;
    % Plot's title and legend
    xlabel('frequency (Hz)');
    ylabel('dBFS');
    legend({'Input', 'Threshold', 'ATQ', 'Delta+', 'Delta-'}, ...
        'Location','best','Orientation','vertical');
    title('DynamicEQ values');

    

    % SECOND PLOT: IN vs OUT
    subplot(1,2,2);
    DRYplot= semilogx(frequencies, DryPlot, 'red');
    hold on;
    WETplot= semilogx(frequencies, WetPlot, 'Color', wetColor);
    hold off;
    xlabel('frequency (Hz)');
    ylabel('dBFS');
    legend({'IN','OUT'}, 'Location','best','Orientation','vertical')    
    title('IN vs OUT');




    % Increment block number
    blockNumber=blockNumber+1;

end



% THIRD PLOT: eq frequency response
A_=ones(3,length(A));
A_(2:3,:)=A;
fvplot = fvtool([B.',A_.'],'FrequencyScale','log','Fs',fs, ...
    'FrequencyRange', 'Specify freq. vector', ...
    'Color','white');
fvplot.FrequencyVector=frequencies;




% Play wet signal
soundsc(wetSignal,fs);

 

