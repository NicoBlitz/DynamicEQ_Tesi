
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
saveFile = false;
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
% Is the setup part where the functions will be executed only the first
% time you run the project

% threshold and wet signal initialization
threshold = zeros(nfft,1);
thresholdBuffer_L = zeros(nfilts,totBlocks);
thresholdBuffer_R = zeros(nfilts,totBlocks);
wetSignal = zeros(duration,2);

%external parameters initialization 
UIinGain = 0.9; %[0,1]
UIscGain = 0.2; %[0,1]
UIoutGain = 1.0; %[0,1]

UIcompAmount = 0.2; %[-1,1] "MASKED"
UIexpAmount = 0.9; %[-1,1] "CLEAR"
UIatqWeight = 0.0; %[0,1] ???
UIstereoLinked = 0.0; %[0,1] ???
UImix= 1.0; %[0,1]

UIparams = struct( ...
    'gain', struct( ...
        'in', UIinGain, ...
        'out', UIoutGain, ...
        'sc', UIscGain ...
        ), ...
    'eq', struct( ...
        'atq', UIatqWeight, ...  % cleanUp
        'stereolink', UIstereoLinked, ... %stereo linked
        'comp', UIcompAmount, ... % comp
        'exp', UIexpAmount, ... % exp
        'mix', UImix ...
        ) ... % mix
    );


% Get Absolute Threshold in Quiet
ATQ_decimated = getATQ(fCenters); %ATQ_decimated in ...
ATQ_scaled = scaleATQ(ATQ_decimated, UIparams.eq.atq, ATQ_lift, min_dbFS);


% Create main plot
%figure;

blockNumber=1;

% --------------------------------------------------------------------------------
% PROCESS BLOCK 
% Loop section. Execute algorithm from first to last sample of the file 
% with a step of buffersize*step_block
%dove sta la decimazione dei file input e sidechain?

for offset = 1:(buffersize*step_block):length(input)-buffersize
    

    % Calculate last sample of the block
    blockEnd = offset+buffersize-1;
  
    % Shift among samples and multiply by Input and Sidechain's UI Gain 
    blockIN_Gain = input(offset:blockEnd,:) * UIparams.gain.in;
    blockSC_Gain = scInput(offset:blockEnd,:) * UIparams.gain.sc * 3; % / spread_exp
    
    % Calculate block's threshold depending on our psychoacoustic model  
    [delta, threshold, input_Freq_dB] = getDelta(blockSC_Gain, blockIN_Gain, ATQ_scaled, fs, fbank, spreadingfunctionmatrix, frequencies); % Left channel rel. threshold

    % Stereo linked delta processing
    % if delta signal is stereo, it makes and average between left and
    % right channel, to avoid large gain differences between the 2 channel
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
    %subplot(1,2,1);

    nfilts=size(fbank,1);
    sc_tmp = getMagnitudeFD(blockSC_Gain, fs, nfilts, frequencies, fbank);
    sidech(:,1) = amp2db(sc_tmp(:,1));

    hold on;
    % Plot input
    %sidechPlot= semilogx(fCenters, sidech(:,1), 'Color', [0.360 0.840 0.540],'LineWidth',2);

    % Plot relative and absolute thresholds
    %INplot_R= semilogx(fCenters, input_Freq_dB(:,1), 'Color', 'blue','LineWidth',2);
    %ATQplot = semilogx(fCenters, ATQ_scaled, ':', 'Color', [0.850 0.380 0.840],'LineWidth',2);
    %THplot= semilogx(fCenters, threshold(:,1), '--', 'Color', [0 0.4470 0.7410],'LineWidth',2);
    delta = semilogx(fCenters, delta_modulated(:,1), '--', 'Color', [0 0.4470 0.7410],'LineWidth',2);
    deltaC = semilogx(fCenters, delta_clipped(:,1), 'Color', [0.935 0.380 0.284],'LineWidth',2);
    

    if(stereo_plot==true)
    end
    % Plot delta negative and positive.
%     deltaPlot_L= bar(fCenters, delta_modulated(:,1), 'b');
%     if(stereo_plot==true)
%     deltaPlot_R= bar(fCenters, delta_modulated(:,2), 'r');
%     end
    %DLT_RAWplot = semilogx(fCenters, delta(:,1), ':black','LineWidth',2);
    %DLT_NCplot = semilogx(fCenters, delta_modulated(:,1), '--magenta','LineWidth',2);
    %DLTplot = semilogx(fCenters, delta_clipped(:,1), 'red','LineWidth',2);
    zeroAxis = semilogx(fCenters, zeros(32), 'black');
    topAxis = semilogx(fCenters, ones(32).*25, 'white');
    
    hold off;

    % Plot's title and legend
    xlabel('frequency (Hz)');
    ylabel('dBFS');
    
    if(stereo_plot==true)
    legend({'Input_R', 'ATQ', 'Threshold_L', 'Threshold_R', 'Delta_L', 'Delta_R'}, ...
        'Location','east','Orientation','vertical');
    else 
    legend({'Delta', 'Delta Clipped'}, ...
        'Location','east','Orientation','vertical');
    end

   

    
%     % --------------- SECOND PLOT: IN vs OUT
%     subplot(1,2,2);
%     SCplot_L= semilogx(frequencies, SCPlot(:,1), ':black');
%     hold on;
%     if(stereo_plot==true)
%     SCplot_R= semilogx(frequencies, SCPlot(:,2), ':', 'Color', [0.1350 0.0780 0.0840]);
%     end
% 
%     DRYplot_L= semilogx(frequencies, DryPlot(:,1), '--red');
%     if(stereo_plot==true)
%     DRYplot_R= semilogx(frequencies, DryPlot(:,2), '--', 'Color', [0.8350 0.0780 0.1840]);
%     end
% 
%     WETplot_L= semilogx(frequencies, WetPlot(:,1), 'blue');
%     if(stereo_plot==true)
%     WETplot_R= semilogx(frequencies, WetPlot(:,2), 'Color', [0 0.4470 0.7410]);
%     end
% 
%     hold off;
%     xlabel('frequency (Hz)');
%     ylabel('dBFS');
%     if(stereo_plot==true)
%     legend({'SC_L', 'SC_R', 'IN_L', 'IN_R', 'OUT_L', 'OUT_R'}, 'Location','best','Orientation','vertical')    
%     else
%     legend({'SC_L', 'IN_L', 'OUT_L'}, 'Location','best','Orientation','vertical')    
%  
%     end
%     title('IN vs OUT');


   % --------------- THIRD PLOT: current block's eq frequency response (will slow down execution)
%    if(blockByBlock_switch)
%     close(fvplot);
%     fvplot = fvtool([num_L.',[ones(1,length(num_L)); den_L].'], 'FrequencyScale','log','Fs',fs, ...
%         'FrequencyRange', 'Specify freq. vector', 'FrequencyVector', frequencies,...
%         'Color','white');
%    end

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
 

