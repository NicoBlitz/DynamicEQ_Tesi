
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

% Internal plotting variables
blockByBlock_switch=true;
saveFile=true;
stereo_plot = false;
scShift_switch=true; sc_shift = 120000;
doubleSine_switch=true; doubleSine_shift = 150000;
wholeFile_switch=true;
step_block=40; 
duration = 2000000;

th_buffer_max_plot_duration = 200;

if(blockByBlock_switch)
saveFile=false;
end

if(saveFile) 
    step_block=1; 
    blockByBlock_switch=false;
    wholeFile_switch=true;
    scShift_switch=false;
    th_buffer_max_plot_duration = 1000;
end


% Files reading
michael= "audio\Michael Buble edit.wav";
sweep="audio\sineSweep.wav";
whiteN="audio\whiteNoise_long.wav";
pinkN="audio\pink noise.wav";
buzz="audio\Explainer_Video_Clock_Alarm_Buzz_Timer_5.wav";
input = audioread(whiteN);
scInput = audioread(sweep);


if(doubleSine_switch)
scInput= scInput(1:(end-doubleSine_shift+1),:)+scInput(doubleSine_shift:end,:); 
end
if(scShift_switch)
scInput = scInput(sc_shift:end,:); % shift scInput of x samples
end
if(not(wholeFile_switch))
duration= min(duration,length(input)); %take just first x samples, if x < input length
duration= min(duration,length(scInput)); %take just first x samples, if x < scInput length
else
duration= min(length(input),length(scInput));
end
totBlocks=ceil(duration/(buffersize*step_block))-1; % calculate how many blocks will be processed

% input signals truncation at "duration"th sample
input=input(1:duration,:);
scInput=scInput(1:duration,:);


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

UIcompAmount = 1.0; % da -1 a 1 - "MASKED"
UIexpAmount = 0.0; % "CLEAR"
UIatqWeight = 0.0;
UIstereoLinked = 0.0;
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

blockNumber=1;

% --------------------------------------------------------------------------------
% PROCESS BLOCK 
% Execute algorithm from first to last sample of the file with a step of buffersize

for offset = 1:(buffersize*step_block):length(input)-buffersize
    

    % Calculate last sample of the block
    blockEnd = offset+buffersize-1;
  
    % Shift among samples and multiply by Input and Sidechain's UI Gain 
    blockIN_Gain = input(offset:blockEnd,:) * UIparams.gain.in;
    blockSC_Gain = scInput(offset:blockEnd,:) * UIparams.gain.sc  * 3; % / spread_exp
    
    % Calculate block's threshold depending on our psychoacoustic model  
    relative_threshold= getRelativeThreshold(blockSC_Gain, fs, fbank, spreadingfunctionmatrix); % Left channel rel. threshold

    % Comparing with relative and absolute threshold
    threshold = max(relative_threshold, ATQ_scaled);

    % Input frequency domain and decimation
    input_Freq_dB = getMagnitudeFD(blockIN_Gain, fs, nfilts, fbank); % Left channel input fd and decimation

    % Getting delta
    delta = input_Freq_dB - threshold;
    
    % Set delta to zero when threshold (sidechain signal) is under dGating_thresh value, with a knee of dGating_knee (both in positive and negative direction)
    THclip = (1+tanh((threshold-dGating_thresh)/dGating_knee))/2;
    %INclip = (1+tanh((input_Freq_dB-dGating_thresh)/dGating_knee))/2;

      % UI modulations
    delta_modulated = modulateDelta(delta, UIparams.eq, maxGainModule); % to clip the delta, add maxGainModule as a third parameter
   
    delta_clipped = delta_modulated .* THclip;
%     delta_adjust = delta_adjust .* INclip; 

   
    % Equalization
    [wetBlock(:,1), num_L, den_L] = peakFilterEq(blockIN_Gain(:,1), delta_clipped(:,1), EQcent, EQband, myFilter_L, filterOrder, num_L, den_L); % Left channel EQing
    [wetBlock(:,2), num_R, den_R] = peakFilterEq(blockIN_Gain(:,2), delta_clipped(:,2), EQcent, EQband, myFilter_R, filterOrder, num_R, den_R); % Right Channel EQing
    
    
    % Threshold reconstruction (current block concatenation)
    thresholdBuffer_L(:,blockNumber)=threshold(:,1);
    thresholdBuffer_R(:,blockNumber)=threshold(:,2);
    
    % Signal reconstruction (current block concatenation)
    wetSignal(offset:blockEnd,:)= wetBlock * UIparams.gain.out;
    
    % PLOT PREPARATION
    DryPlot= getMagnitudeFD(blockIN_Gain, fs, nfilts); % No decimation

    SCPlot= getMagnitudeFD(blockSC_Gain, fs, nfilts); % No decimation

    WetPlot= getMagnitudeFD(wetBlock, fs, nfilts); % No decimation

 
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
%     deltaPlot_L= bar(fCenters, delta_modulated(:,1), 'b');
%     if(stereo_plot==true)
%     deltaPlot_R= bar(fCenters, delta_modulated(:,2), 'r');
%     end
    DLT_RAWplot = semilogx(fCenters, delta(:,1), ':black');
    DLT_NCplot = semilogx(fCenters, delta_modulated(:,1), '--magenta');
    DLTplot = semilogx(fCenters, delta_clipped(:,1), 'red');



    
    hold off;

    % Plot's title and legend
    xlabel('frequency (Hz)');
    ylabel('dBFS');
    if(stereo_plot==true)
    legend({'Input_L', 'Input_R', 'ATQ', 'Threshold_L', 'Threshold_R', 'Delta_L', 'Delta_R'}, ...
        'Location','southoutside','Orientation','vertical');
    else 
    legend({'Input_L', 'ATQ', 'Threshold_L', 'Delta raw_L', 'Delta modulated_L', 'Delta clipped_L'}, ...
    'Location','southoutside','Orientation','vertical');
    end
    title('DynamicEQ values');

   

    % --------------- SECOND PLOT: IN vs OUT
    subplot(1,2,2);
    SCplot_L= semilogx(frequencies, SCPlot(:,1), ':black');
    hold on;
    if(stereo_plot==true)
    SCplot_R= semilogx(frequencies, SCPlot(:,2), ':', 'Color', [0.1350 0.0780 0.0840]);
    end

    DRYplot_L= semilogx(frequencies, DryPlot(:,1), '--red');
    if(stereo_plot==true)
    DRYplot_R= semilogx(frequencies, DryPlot(:,2), '--', 'Color', [0.8350 0.0780 0.1840]);
    end

    WETplot_L= semilogx(frequencies, WetPlot(:,1), 'blue');
    if(stereo_plot==true)
    WETplot_R= semilogx(frequencies, WetPlot(:,2), 'Color', [0 0.4470 0.7410]);
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


   % --------------- THIRD PLOT: current block's eq frequency response (will slow down execution)
   if(blockByBlock_switch)
    close(fvplot);
    fvplot = fvtool([num_L.',[ones(1,length(num_L)); den_L].'], 'FrequencyScale','log','Fs',fs, ...
        'FrequencyRange', 'Specify freq. vector', 'FrequencyVector', frequencies,...
        'Color','white');
    dbstop in TheMasker_Main.m at 253 if blockByBlock_switch;
   end

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
hmTrucation=min(th_buffer_max_plot_duration,totBlocks);
heatmap(blocks(1,totBlocks-hmTrucation+1:end), round(fCenters), thresholdBuffer_L(:,totBlocks-hmTrucation+1:end));
title('Threshold buffer (left channel)');

% Play wet signal
soundsc(wetSignal,fs);
if (saveFile) 
    if (doubleSine_switch) 
    audiowrite("exports\whiteNoise+DoubleSine\output_doubleSine.wav",wetSignal,fs);
    else
    audiowrite("exports\whiteNoise+Sine\output_sine.wav",wetSignal,fs);
    end
end
 

