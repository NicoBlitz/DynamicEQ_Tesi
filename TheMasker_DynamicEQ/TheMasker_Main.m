
close all;
clear;

% Add audio and dependencies folders to path
folder = fileparts(which(mfilename)); 
addpath(genpath(folder));

% Creates constant variables
Shared;

%Initialize freq. response plot
% num_L=[ones(1,nfilts); zeros(2,nfilts)];
% den_L=zeros(2,nfilts);
% fvplot = fvtool([num_L.',[ones(1,length(num_L)); den_L].']);
% num_R=num_L;
% den_R=den_L;

% Internal plotting variables
blockByBlock_switch=true;
saveFile=false;
stereo_plot = false;
scShift_switch=false; sc_shift = 120000;
doubleSine_switch=false; doubleSine_shift = 150000;
wholeFile_switch=true;
step_block=10; 
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
michael= "audio/Michael Buble edit.wav";
sweep="audio/sineSweep.wav";
whiteN="audio/whiteNoise_long.wav";
pinkN="audio/pink noise.wav";
buzz="audio/Explainer_Video_Clock_Alarm_Buzz_Timer_5.wav";
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
UIatqWeight = 0.8; % cleanup
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
ATQ_decimated = getATQ(fCenters);
ATQ_scaled = scaleATQ(ATQ_decimated, UIparams.eq.atq, ATQ_lift, min_dbFS);


% Create main plot
figure;

blockNumber=1;

% --------------------------------------------------------------------------------
% PROCESS BLOCK 
% Execute algorithm from first to last sample of the file with a step of buffersize*step_block

for offset = 1:(buffersize*step_block):length(input)-buffersize
    

    % Calculate last sample of the block
    blockEnd = offset+buffersize-1;
  
    % Shift among samples and multiply by Input and Sidechain's UI Gain 
    blockIN_Gain = input(offset:blockEnd,:) * UIparams.gain.in;
    blockSC_Gain = scInput(offset:blockEnd,:) * UIparams.gain.sc * 3; % / spread_exp
    
    % Calculate block's threshold depending on our psychoacoustic model  
    [delta, threshold, input_Freq_dB] = getDelta(blockSC_Gain, blockIN_Gain, ATQ_scaled, fs, fbank, spreadingfunctionmatrix, frequencies); % Left channel rel. threshold

    % Stereo linked delta processing
    if (size(delta,2)==2)
        delta = stereoLinkedProcess(delta, UIparams.eq.stereolink);
    end

    % UI modulations
    delta_modulated = modulateDelta(delta, UIparams.eq, maxGainModule); % to clip the delta, add maxGainModule as a third parameter
   
    delta_clipped = scaleDelta(delta_modulated, threshold, dGating_thresh, dGating_knee);
    %delta_clipped = delta_modulated;

    % Equalization
    wetBlock(:,1) = filterBlock(blockIN_Gain(:,1), delta_clipped(:,1), bandFreqs, fs); % Left channel EQing
    wetBlock(:,2) = filterBlock(blockIN_Gain(:,2), delta_clipped(:,2), bandFreqs, fs); % Right Channel EQing
    
    % Threshold reconstruction (current block concatenation)
    thresholdBuffer_L(:,blockNumber) = threshold(:,1);
    thresholdBuffer_R(:,blockNumber) = threshold(:,2);
    
    % Signal reconstruction (current block concatenation)
    wetBlock_Gain = wetBlock * UIparams.gain.out;
    wetSignal(offset:blockEnd,:)= wetBlock_Gain;
    
    % PLOT PREPARATION
    DryPlot= amp2db(getMagnitudeFD(blockIN_Gain, fs, nfilts, frequencies)); % No decimation

    SCPlot=  amp2db(getMagnitudeFD(blockSC_Gain, fs, nfilts, frequencies)); % No decimation

    WetPlot= amp2db(getMagnitudeFD(wetBlock_Gain, fs, nfilts, frequencies)); % No decimation

 
    % ----------------- FIRST PLOT:  
    clf('reset');
    subplot(1,2,1);

    % Plot input
    INplot_L= semilogx(fCenters, input_Freq_dB(:,1), 'blue','LineWidth', 2);
    hold on;
    if(stereo_plot==true)
    INplot_R= semilogx(fCenters, input_Freq_dB(:,2), 'Color', 'red','LineWidth', 2);
    end
    % Plot relative and absolute thresholds
    
    ATQplot = semilogx(fCenters, ATQ_scaled, ':', 'Color', [0.2, 0.7, 0.4], 'LineWidth', 2);
    THplot_L= semilogx(fCenters, threshold(:,1), '--', 'Color', [0 0.4470 0.7410],'LineWidth', 2);
    if(stereo_plot==true)
    THplot_R= semilogx(fCenters, threshold(:,2), '--', 'Color', [0.9350 0.0780 0.1840],'LineWidth', 2);
    end
    % Plot delta negative and positive.
%     deltaPlot_L= bar(fCenters, delta_modulated(:,1), 'b');
%     if(stereo_plot==true)
%     deltaPlot_R= bar(fCenters, delta_modulated(:,2), 'r');
%     end
    DLT_RAWplot = semilogx(fCenters, delta(:,1), ':black', 'LineWidth', 2);
    DLT_NCplot = semilogx(fCenters, delta_modulated(:,1), '--magenta', 'LineWidth', 2);
    DLTplot = semilogx(fCenters, delta_clipped(:,1), 'red', 'LineWidth', 2);


    
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
%    if(blockByBlock_switch)
%     close(fvplot);
%     fvplot = fvtool([num_L.',[ones(1,length(num_L)); den_L].'], 'FrequencyScale','log','Fs',fs, ...
%         'FrequencyRange', 'Specify freq. vector', 'FrequencyVector', frequencies,...
%         'Color','white');
%    end

    % Increment block number
    blockNumber=blockNumber+step_block;
    dbstop in TheMasker_Main.m at 249 if blockByBlock_switch;

end

% --------------------- THIRD PLOT: last block's eq frequency response 
% close(fvplot);
% fvplot = fvtool([num_L.',[ones(1,length(num_L)); den_L].'],'FrequencyScale','log','Fs',fs, ...
%     'FrequencyRange', 'Specify freq. vector', 'FrequencyVector', frequencies,...
%     'Color','white');

% FOURTH PLOT: threshold over time
% blocks=linspace(1,totBlocks,totBlocks);
% hmTrucation=min(th_buffer_max_plot_duration,totBlocks);
% heatmap(blocks(1,totBlocks-hmTrucation+1:end), round(fCenters), thresholdBuffer_L(:,totBlocks-hmTrucation+1:end));
% title('Threshold buffer (left channel)');

% Play wet signal
soundsc(wetSignal,fs);
if (saveFile) 
    if (doubleSine_switch) 
    audiowrite("exports\whiteNoise+DoubleSine\output_doubleSine.wav",wetSignal,fs);
    else
    audiowrite("exports\whiteNoise+Sine\output_sine.wav",wetSignal,fs);
    end
end
 

