
function scopeHandles = TheMasker_Main( ...
    genCode,plotResults,numTSteps)
close all;
bdclose all
% MULTIBANDAUDIOCOMPRESSIONEXAMPLEAPP Initialize and execute audio
% multiband dynamic range compression example. The results are displayed
% using scopes. The function returns the handles to the scope and UI
% objects.
%
% Inputs:
%   genCode      - If true, use generated MEX file for simulation.
%                  Otherwise, use the MATLAB function. false if
%                  unspecified.
%   numTSteps    - Number of times the algorithm is executed in a loop. Inf
%                  if unspecified.
%   plotResults  - If true, the results are displayed on scopes. true if
%                  unspecified.
%
% Outputs:
%   scopeHandles - If plotResults is true, handle to the visualization.
%
% This function multibandAudioCompressionExampleApp is only in support of
% MultibandDynamicRangeCompressionExample. It may change in a future
% release.
%

% Copyright 2013-2017 The MathWorks, Inc.

%Creates readers and players from file as persistent
%(persistent=existent inside this function only - maybe necessary for dsp.AudioFileReader structure) 
persistent reader readerSC  player

% Creates Absolute Threshold in quiet and other constant variables
Shared;
% BufferSize=nfft*2;

if isempty(reader)


% Reads audio files (function reader() returns current FRAME)    
    reader = dsp.AudioFileReader('Filename','RockGuitar-16-44p1-stereo-72secs.wav', ...
        'PlayCount',Inf,'SamplesPerFrame',buffersize);
     readerSC = dsp.AudioFileReader('Filename','audio\Michael Bublé - Feeling Good [Official Music Video].wav', ...
        'PlayCount',Inf,'SamplesPerFrame',buffersize);

% UNCOMMENT TO SWITCH TO "ALARM SOUND"     
%     readerSC = dsp.AudioFileReader('Filename','audio\Explainer_Video_Clock_Alarm_Buzz_Timer_5.wav', ...
%        'PlayCount',Inf,'SamplesPerFrame',nfft*2).';

    player = audioDeviceWriter('SampleRate',fs,'BufferSize',buffersize);
end





% Default values for inputs of TheMasker_Main
if nargin < 3
    numTSteps = Inf; % Run until user stops simulation. 
end
if nargin < 2
    plotResults = true; % Plot results
end
if nargin == 0
    genCode = false; % Do not generate code. 
end




% Create tuning UI 
param = struct([]);
%Params from "Multiband compression example app"
param(1).Name = 'Band 1 Compression Factor';
param(1).InitialValue = 5;
param(1).Limits =  [1, 100];
param(2).Name = 'Band 1 Threshold (dB)';
param(2).InitialValue = -5;
param(2).Limits = [-80, 0];
param(3).Name = 'Band 1 Attack Time (s)';
param(3).InitialValue = 0.005;
param(3).Limits =  [0, 4];
param(4).Name = 'Band 1 Release Time (s)';
param(4).InitialValue = 0.100;
param(4).Limits = [0, 4];
param(5).Name = 'Band 2 Compression Factor';
param(5).InitialValue = 5;
param(5).Limits =  [1, 100];
param(6).Name = 'Band 2 Threshold (dB)';
param(6).InitialValue = -10;
param(6).Limits = [-80, 0];
param(7).Name = 'Band 2 Attack Time (s)';
param(7).InitialValue = 0.005;
param(7).Limits =  [0, 4];
param(8).Name = 'Band 2 Release Time (s)';
param(8).InitialValue = 0.1;
param(8).Limits = [0, 4];
param(9).Name = 'Band 3 Compression Factor';
param(9).InitialValue = 5;
param(9).Limits =  [1, 100];
param(10).Name = 'Band 3 Threshold (dB)';
param(10).InitialValue = -20;
param(10).Limits = [-80, 0];
param(11).Name = 'Band 3 Attack Time (s)';
param(11).InitialValue = 0.002;
param(11).Limits =  [0, 4];
param(12).Name = 'Band 3 Release Time (s)';
param(12).InitialValue = 0.050;
param(12).Limits = [0, 4];
param(13).Name = 'Band 4 Compression Factor';
param(13).InitialValue = 5;
param(13).Limits =  [1, 100];
param(14).Name = 'Band 4 Threshold (dB)';
param(14).InitialValue = -30;
param(14).Limits = [-80, 0];
param(15).Name = 'Band 4 Attack Time (s)';
param(15).InitialValue = 0.002;
param(15).Limits =  [0, 4];
param(16).Name = 'Band 4 Release Time (s)';
param(16).InitialValue = 0.050;
param(16).Limits = [0, 4];

%Other params (masker?)
param(17).Name = 'Range(k)';
param(17).InitialValue = 0.0;
param(17).Limits = [0, 80];

param(18).Name = 'ATQ influence';
param(18).InitialValue = 0.0;
param(18).Limits = [0, 1];


tuningUI = HelperCreateParamTuningUI(param, ...
    'Multiband Dynamic Compression Example');

set(tuningUI,'Position',[57 221 571 902]);


% PREPARE TO PLAY

%Create 1 matlab figure
figure;

    % Create the spectrum (Log_magn)
%     mask = SpectralMaskSpecification("EnableMasks")

    scope = dsp.SpectrumAnalyzer("SampleRate", fs, "PlotAsTwoSidedSpectrum", false,...
        "FrequencyScale","Log", "SpectrumType", "Power density", ...
        "SpectrumUnits", "dBFS",...
        "MeasurementChannel", 3, ...
        "FFTLengthSource","Property",...
        "FFTLength",nfft, ...
         "FrequencyVector", transpose(frequencies), ...
         "FrequencyVectorSource", "property", ...
         "Window","Hamming",...
        "AxesScaling","Manual"...
        );
    set(scope.SpectralMask,EnabledMasks='upper');

%         "SpectralMask", mask...
%         "YLimits",[-80 200],...

%     scope.SpectralMask.EnabledMasks("upper");
    
    
    show(scope);





% PROCESS BLOCK

% Execute algorithm from first to last sample of the file with a step of nfft*2 

for offset = reader.ReadRange(1):reader.SamplesPerFrame:reader.ReadRange(2)

    
    S = HelperUnpackUIData(tuningUI);
    
  

    if S.Stop     % If "Stop Simulation" button is pressed
        break;
    end
    if S.Pause
        continue;
    end
    

samples=readerSC()
       

 player(samples);

   if plotResults
                    

        [X,Delta] = FFT_Analysis(samples,nfft,min_power);
        
        maskThreshold = maskingThreshold(X, W, W_inv,fs,spreadingfuncmatrix,alpha_exp,nfft,ATQ_current,barks,frequencies);
        
%         plotIt(frequencies,maskThreshold,'log','dB','mX');
        %maskThreshold = maskThreshold - Delta;
        upperMask = [frequencies.', maskThreshold.'];
        set(scope.SpectralMask,UpperMask=upperMask);
        
        % Visualize results
        scope(samples);
    end


    audio = HelperMultibandCompressionSim(S,nfft,fs,samples);
end

% Clean up
    if plotResults
        release(scope);
        scopeHandles.scope = scope;
    else
        scopeHandles.scope = [];
    end
close(tuningUI)
clear HelperMultibandCompressionSim
clear HelperMultibandCompressionSim_mex
clear HelperUnpackUIData
 

