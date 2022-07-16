

function scopeHandles = TheMasker( ...
    genCode,plotResults,numTSteps)


Common;
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

% Default values for inputs
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

%masker params

param(17).Name = 'Range(k)';
param(17).InitialValue = 0.0;
param(17).Limits = [0, 80];

tuningUI = HelperCreateParamTuningUI(param, ...
    'Multiband Dynamic Compression Example');

set(tuningUI,'Position',[57 221 571 902]);


% PREPARE TO PLAY
freq = TH(:,FREQS);

if plotResults

    % Plot the compressed and uncompressed signals
    L = FFT_SIZE;
    SampleRate = SAMPLE_RATE;
    scope = dsp.SpectrumAnalyzer("SampleRate", SampleRate, "PlotAsTwoSidedSpectrum", false,...
        "FrequencyScale","Log", "SpectrumType", "Power density", ...
        "MeasurementChannel", 3, ...
        "FFTLengthSource","Property",...
        "FFTLength",FFT_SIZE, ...
        "FrequencyVector", transpose(freq), ...
        "FrequencyVectorSource", "property", ...
        "Window","Hamming",...
        "YLimits",[-80 200],...
        "AxesScaling","Manual"...
        );

    
 
 %"FFTLength", L, "Window","Hamming",...
        %"InputUnits", "dBW" ...
   


    scope.SpectralMask.EnabledMasks = "upper";
    
    
    show(scope);
end

% PROCESS BLOCK

% Execute algorithm
count = 1;
while count < numTSteps
    
    S = HelperUnpackUIData(tuningUI);
    
  

    if S.Stop     % If "Stop Simulation" button is pressed
        break;
    end
    if S.Pause
        continue;
    end
    
    if genCode
        audio = HelperMultibandCompressionSim_mex(S);
    else    
        audio = HelperMultibandCompressionSim(S);
    end

   if plotResults
        % Visualize results
        
        maskThreshold = getThreshold(audio, L, SampleRate);
        %maskThreshold = maskThreshold - Delta;
        upperMask = [freq, transpose(maskThreshold)];
        set(scope.SpectralMask,UpperMask=upperMask);
        scope(audio);
    end
    count = count + 1;
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
 

end