
close all;
clear;

% Add audio and dependencies folders to path
folder = fileparts(which(mfilename)); 
addpath(genpath(folder));

% Creates constant variables
Shared;

%Initialize freq. response plot
B=ones(3,nfilts);
A=B;
fvplot = fvtool([B.',A.']);

% Read entire files
input = audioread("audio\Michael Buble edit.wav");
% input = audioread("audio\sineSweep.wav");
scInput = audioread("audio\Michael Buble edit.wav");
% scInput = audioread("audio\Explainer_Video_Clock_Alarm_Buzz_Timer_5.wav");
% scInput = audioread("audio\sineSweep.wav");
% scInput = scInput(200000:end,:); % shift scInput of x samples

duration= min(20000,length(input)); %take just first x samples, if x < input length
totBlocks=ceil(duration/buffersize)-1; % calculate how many blocks will be processed

% input signals truncation at "duration"th sample
input=input(1:duration,:);
scInput=scInput(1:duration,:);


% -------------------------------------------------------------------------------------
% PREPARE TO PLAY 

% signals initialization
threshold = zeros(nfft,1);
thresholdBuffer = zeros(nfilts,totBlocks);
wetSignal = zeros(duration,2);

% parameters initialization
UIinGain = 0.9;
UIscGain = 0.9;
UIoutGain = 1.0;

UIatqWeight = 1.0;
UIseparation = true;
UIcompAmount = 1.0;
UIexpAmount = 1.0;
UImix= 1.0;

UIparams = struct('gain', struct( ...
    'in', UIinGain, ...
    'out', UIoutGain, ...
    'sc', UIscGain), ...
                    'eq', struct( ...
    'atq', UIatqWeight, ...  % cleanUp
    'sep', UIseparation, ... % switch separate
    'comp', UIcompAmount, ... % comp
    'exp', UIexpAmount, ... % exp
    'mix', UImix) ... % mix
    );


% Get Absolute Threshold in Quiet
ATQ_decimated = getATQ(frequencies, fbank);
ATQ_scaled = scaleATQ(ATQ_decimated, UIparams.eq.atq, ATQ_lift, min_dbFS);


% Create main plot
figure;



blockNumber=1;

% --------------------------------------------------------------------------------
% PROCESS BLOCK 
% Execute algorithm from first to last sample of the file with a step of buffersize

for offset = 1:buffersize:length(input)-buffersize
    

    % Calculate last sample of the block
    blockEnd = offset+buffersize-1;
  
    % Shift among samples and multiply by Input and Sidechain's UI Gain 
    blockIN_Gain = input(offset:blockEnd,:) * UIparams.gain.in;
    blockSC_Gain = scInput(offset:blockEnd,:) * UIparams.gain.sc;
    
    % Calculate block's threshold depending on our psychoacoustic model  
    relative_threshold = getRelativeThreshold(blockSC_Gain, fs, fbank, spreadingfunctionmatrix);
    
    % Comparing with relative and absolute threshold
    threshold = max(relative_threshold, ATQ_scaled);

    % Input frequency domain and decimation
    input_Freq_dB = getMagnitudeFD(blockIN_Gain, fs, fbank);
    
    % Getting delta
    delta = input_Freq_dB - threshold;
    
    % UI separation switch
    delta_modulated = modulateDelta(delta, UIparams.eq, maxGainModule);
    
    % Equalization
    [wetBlock,B,A] = peakFilterEq(blockIN_Gain, delta_modulated, EQcent, EQband, myFilter, filterOrder);
        
    % Threshold reconstruction (current block concatenation)
    thresholdBuffer(:,blockNumber)=threshold;
    
    % Signal reconstruction (current block concatenation)
    wetSignal(offset:blockEnd,:)= wetBlock * UIparams.gain.out;
    
    % PLOT PREPARATION
    wetBlock_Freq_dB = getMagnitudeFD(wetBlock, fs, fbank);     % "Decimation" of the wet Signal to fit in the same plot (DynamicEQ values)
    DryPlot= getMagnitudeFD(blockIN_Gain, fs); % No decimation
    SCPlot= getMagnitudeFD(blockSC_Gain, fs); % No decimation
    WetPlot= getMagnitudeFD(wetBlock, fs); % No decimation
    gainReduction = wetBlock_Freq_dB - input_Freq_dB;
 
    % FIRST PLOT:  
    clf('reset');
    subplot(1,2,1);

    % Plot input
    INplot= semilogx(fCenters, input_Freq_dB, 'blue');
    hold on;
    
    % Plot relative and absolute thresholds
    ATQplot = semilogx(fCenters, ATQ_scaled, '--red');
    THplot= semilogx(fCenters, threshold, '--black');
    
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
    legend({'Input', 'ATQ', 'Threshold', 'Delta+', 'Delta-'}, ...
        'Location','best','Orientation','vertical');
    title('DynamicEQ values');

   

    % SECOND PLOT: IN vs OUT
    subplot(1,2,2);
    SCplot= semilogx(frequencies, SCPlot, 'black');
    hold on;
    DRYplot= semilogx(frequencies, DryPlot, 'red');
    WETplot= semilogx(frequencies, WetPlot, 'blue');
    hold off;
    xlabel('frequency (Hz)');
    ylabel('dBFS');
    legend({'SC','IN','OUT'}, 'Location','best','Orientation','vertical')    
    title('IN vs OUT');


    % THIRD PLOT: temporary eq frequency response (uncommenting will slow down execution)
%     close(fvplot);
%     fvplot = fvtool([B.',[ones(1,length(A)); A].'],'FrequencyScale','log','Fs',fs, ...
%         'FrequencyRange', 'Specify freq. vector', 'FrequencyVector', frequencies,...
%         'Color','white');


    % Increment block number
    blockNumber=blockNumber+1;

end

% THIRD PLOT: last block's eq frequency response 
close(fvplot);
fvplot = fvtool([B.',[ones(1,length(A)); A].'],'FrequencyScale','log','Fs',fs, ...
    'FrequencyRange', 'Specify freq. vector', 'FrequencyVector', frequencies,...
    'Color','white');

% FOURTH PLOT: threshold over time
blocks=linspace(1,totBlocks,totBlocks);
hmTrucation=min(300,length(blocks));
heatmap(blocks(1,totBlocks-hmTrucation+1:end), round(fCenters), thresholdBuffer(:,totBlocks-hmTrucation+1:end));


% Play wet signal
soundsc(wetSignal,fs);

 

