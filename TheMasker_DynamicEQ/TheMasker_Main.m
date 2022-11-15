
close all;
clear;

% Add audio and dependencies folders to path
folder = fileparts(which(mfilename)); 
addpath(genpath(folder));

% Creates constant variables
Shared;


%Initialize freq. response plot
num_L=[ones(1,nfilts); zeros(2,nfilts)];
den_L=zeros(2,nfilts);
fvplot = fvtool([num_L.',[ones(1,length(num_L)); den_L].']);
num_R=num_L;
den_R=den_L;


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
scInput=scInput(1:duration,:)*0;


% -------------------------------------------------------------------------------------
% PREPARE TO PLAY 

% signals initialization
threshold = zeros(nfft,1);
thresholdBuffer_L = zeros(nfilts,totBlocks);
thresholdBuffer_R = zeros(nfilts,totBlocks);
wetSignal = zeros(duration,2);

% parameters initialization
UIinGain = 0.9;
UIscGain = 0.9;
UIoutGain = 1.0;

UIcompAmount = 1.0; % da -1 a 1
UIexpAmount = 1.0;
UIatqWeight = 1.0;
UIstereoLinked = 1.0;
UImix= 1.0;

UIparams = struct('gain', struct( ...
    'in', UIinGain, ...
    'out', UIoutGain, ...
    'sc', UIscGain), ...
                    'eq', struct( ...
    'atq', UIatqWeight, ...  % cleanUp
    'stereolink', UIstereoLinked, ... %stereo linked
    'comp', UIcompAmount, ... % comp
    'exp', UIexpAmount, ... % exp
    'mix', UImix) ... % mix
    );


% Get Absolute Threshold in Quiet
ATQ_decimated = getATQ(frequencies, fbank);
ATQ_scaled = scaleATQ(ATQ_decimated, UIparams.eq.atq, ATQ_lift, min_dbFS);


% Create main plot
figure;

stereo_plot=false;

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
    relative_threshold(:,1)= getRelativeThreshold(blockSC_Gain(:,1), fs, fbank, spreadingfunctionmatrix); % Left channel rel. threshold
    relative_threshold(:,2)= getRelativeThreshold(blockSC_Gain(:,2), fs, fbank, spreadingfunctionmatrix); % Right channel rel. threshold

    % Comparing with relative and absolute threshold
    threshold = max(relative_threshold, ATQ_scaled);

    % Input frequency domain and decimation
    input_Freq_dB(:,1) = getMagnitudeFD(blockIN_Gain(:,1), fs, fbank); % Left channel input fd and decimation
    input_Freq_dB(:,2) = getMagnitudeFD(blockIN_Gain(:,2), fs, fbank); % Right channel input fd and decimation

    % Getting delta
    delta = input_Freq_dB - threshold;
    
    % UI separation switch
    delta_modulated = modulateDelta(delta, UIparams.eq, maxGainModule);
    
    

    % Equalization
    [wetBlock(:,1),num_L,den_L] = peakFilterEq(blockIN_Gain(:,1), delta_modulated(:,1), EQcent, EQband, myFilter_L, filterOrder, num_L, den_L); % Left channel EQing
    [wetBlock(:,2),num_R,den_R] = peakFilterEq(blockIN_Gain(:,2), delta_modulated(:,2), EQcent, EQband, myFilter_R, filterOrder, num_R, den_R); % Right Channel EQing
    

    % Threshold reconstruction (current block concatenation)
    thresholdBuffer_L(:,blockNumber)=threshold(:,1);
    thresholdBuffer_R(:,blockNumber)=threshold(:,2);
    
    % Signal reconstruction (current block concatenation)
    wetSignal(offset:blockEnd,:)= wetBlock * UIparams.gain.out;
    
    % PLOT PREPARATION
    DryPlot_L= getMagnitudeFD(blockIN_Gain(:,1), fs); % No decimation
    DryPlot_R= getMagnitudeFD(blockIN_Gain(:,2), fs); % No decimation

    SCPlot_L= getMagnitudeFD(blockSC_Gain(:,1), fs); % No decimation
    SCPlot_R= getMagnitudeFD(blockSC_Gain(:,2), fs); % No decimation

    WetPlot_L= getMagnitudeFD(wetBlock(:,1), fs); % No decimation
    WetPlot_R= getMagnitudeFD(wetBlock(:,2), fs); % No decimation

 
    % ----------------- FIRST PLOT:  
    clf('reset');
    subplot(1,2,1);

    % Plot input
    INplot_L= semilogx(fCenters, input_Freq_dB(:,1), 'blue');
    hold on;
    if(stereo_plot==true)
    INplot_R= semilogx(fCenters, input_Freq_dB(:,2), 'Color', 'red');
    end
    % Plot relative and absolute thresholds
    
    ATQplot = semilogx(fCenters, ATQ_scaled, ':black');
    THplot_L= semilogx(fCenters, threshold(:,1), '--', 'Color', [0 0.4470 0.7410]);
    if(stereo_plot==true)
    THplot_R= semilogx(fCenters, threshold(:,2), '--', 'Color', [0.9350 0.0780 0.1840]);
    end
    % Plot delta negative and positive.
    deltaPlot_L= bar(fCenters, delta_modulated(:,1), 'b');
    if(stereo_plot==true)
    deltaPlot_R= bar(fCenters, delta_modulated(:,2), 'r');
    end

%     deltaNEGplot= bar(fCenters, min(delta_modulated(:,1),0), 'm');
    
    hold off;

    % Plot's title and legend
    xlabel('frequency (Hz)');
    ylabel('dBFS');
    if(stereo_plot==true)
    legend({'Input_L', 'Input_R', 'ATQ', 'Threshold_L', 'Threshold_R', 'Delta_L', 'Delta_R'}, ...
        'Location','best','Orientation','vertical');
    else 
    legend({'Input_L', 'ATQ', 'Threshold_L', 'Delta_L'}, ...
    'Location','best','Orientation','vertical');
    end
    title('DynamicEQ values');

   

    % --------------- SECOND PLOT: IN vs OUT
    subplot(1,2,2);
    SCplot_L= semilogx(frequencies, SCPlot_L, ':black');
    hold on;
    if(stereo_plot==true)
    SCplot_R= semilogx(frequencies, SCPlot_R, ':', 'Color', [0.1350 0.0780 0.0840]);
    end

    DRYplot_L= semilogx(frequencies, DryPlot_L, '--red');
    if(stereo_plot==true)
    DRYplot_R= semilogx(frequencies, DryPlot_R, '--', 'Color', [0.8350 0.0780 0.1840]);
    end

    WETplot_L= semilogx(frequencies, WetPlot_L, 'blue');
    if(stereo_plot==true)
    WETplot_R= semilogx(frequencies, WetPlot_R, 'Color', [0 0.4470 0.7410]);
    end

    hold off;
    xlabel('frequency (Hz)');
    ylabel('dBFS');
    if(stereo_plot==true)
    legend({'SC_L', 'SC_R', 'IN_L', 'IN_R', 'OUT_L', 'OUT_R'}, 'Location','best','Orientation','vertical')    
    else
    legend({'SC_L', 'IN_L', 'OUT_L'}, 'Location','best','Orientation','vertical')    
 
    end
    title('IN vs OUT');


    % --------------- THIRD PLOT: temporary eq frequency response (uncommenting will slow down execution)
%     close(fvplot);
%     fvplot = fvtool([B.',[ones(1,length(A)); A].'],'FrequencyScale','log','Fs',fs, ...
%         'FrequencyRange', 'Specify freq. vector', 'FrequencyVector', frequencies,...
%         'Color','white');


    % Increment block number
    blockNumber=blockNumber+1;

end

% --------------------- THIRD PLOT: last block's eq frequency response 
close(fvplot);
fvplot = fvtool([num_L.',[ones(1,length(num_L)); den_L].'],'FrequencyScale','log','Fs',fs, ...
    'FrequencyRange', 'Specify freq. vector', 'FrequencyVector', frequencies,...
    'Color','white');

% FOURTH PLOT: threshold over time
blocks=linspace(1,totBlocks,totBlocks);
hmTrucation=min(300,length(blocks));
heatmap(blocks(1,totBlocks-hmTrucation+1:end), round(fCenters), thresholdBuffer_L(:,totBlocks-hmTrucation+1:end));
title('Threshold buffer (left channel)');

% Play wet signal
soundsc(wetSignal,fs);

 

