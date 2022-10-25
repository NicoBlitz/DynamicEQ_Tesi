
close all;
%bdclose all

% Add audio and dependencies folders to path
folder = fileparts(which(mfilename)); 
addpath(genpath(folder));

% Creates Absolute Threshold in quiet and other constant variables
Shared;

% Read entire files
[input,fs] = audioread("audio\Michael Buble edit.wav");
[scInput,fs] = audioread("audio\Michael Buble edit.wav");

endSample=20000; %take just first x samples
endSample=min(endSample,length(input));

% input signals truncation at "endSample"th sample
% (if "endSample" is greater than the original duration (in samples),
% "endSample" will be overrided with original duration);
input=input(1:endSample,:);
scInput=scInput(1:endSample,:);



% PREPARE TO PLAY

% signals initialization
duration=length(input);
totBlocks=ceil(duration/buffersize)-1;

sample=linspace(1,duration,duration);
blocks=linspace(1,totBlocks,totBlocks);

threshold = zeros(nfft,1);
%thresholdBuffer = zeros(nfft,duration);
thresholdBuffer = zeros(nfilts,totBlocks);
wetSignal = zeros(duration,2);

% parameters initialization
UIinGain = 0.8;
UIscGain = 0.8;

UIoutGain = 1;

% UI initialization
param = struct([]);
param = SetUIParams(param);

%tuningUI = HelperCreateParamTuningUI(param, ...
%   'Multiband Dynamic Compression Example');

%set(tuningUI,'Position',[57 221 571 902]);


% Create 1 matlab figure
%figure;


% Create the spectrum (Log_magn)
%   mask = SpectralMaskSpecification("EnableMasks")

%     scope = dsp.SpectrumAnalyzer("SampleRate", fs, "PlotAsTwoSidedSpectrum", false,...
%         "FrequencyScale","Log", "SpectrumType", "Power density", ...
%         "SpectrumUnits", "dBFS",...
%         "MeasurementChannel", 3, ...
%         "FFTLengthSource","Property",...
%         "FFTLength",nfft, ...
%         "FrequencyVector", transpose(frequencies), ...
%         "FrequencyVectorSource", "property", ...
%         "Window","Hamming",...
%         "AxesScaling","Manual"...
%         );
%     set(scope.SpectralMask,EnabledMasks='upper');

%         "SpectralMask", mask...

    
%     show(scope);


%S = HelperUnpackUIData(tuningUI);


%---------------------------------------------------------------------------------
% PROCESS BLOCK 

% Execute algorithm from first to last sample of the file with a step of nfft*2 

blockNumber=1;

for offset = 1:buffersize:length(input)-buffersize

blockEnd = offset+buffersize-1;

blockSC = scInput(offset:blockEnd,:);
blockIN = input(offset:blockEnd,:);   

blockIN_Gain = blockIN * UIinGain;
blockSC_Gain = blockSC * UIscGain;

% Calculate block's threshold depending on our psychoacoustic model  
% nfilts already exist in Shared - where ATQ and spreadingFunction are calculated 
threshold = psychoAcousticAnalysis(blockSC_Gain, nfft, fs, fftoverlap, fbank, spreadingfunctionmatrix);
thresholdBuffer(:,blockNumber)=threshold;


%dummy threshold, to be delete
% threshold = getDummyThreshold(nfilts);
% threshold = threshold.';

% Signal processing depending on the threshold just calculated

wetSignal = dynamicEqualization(blockIN_Gain, threshold, nfft, fs, nfilts, frequencies) * UIoutGain;

% Signal reconstruction (current block concatenation)
wetSignal(offset:blockEnd,1)=blockIN_Gain(:,1);
wetSignal(offset:blockEnd,2)=blockIN_Gain(:,2);
                

    %upperMask = [frequencies.', maskThreshold.'];

    %set(scope.SpectralMask,UpperMask=upperMask);
    
    % Visualize results
    


%     audio = HelperMultibandCompressionSim(S,nfft,fs,samples);
%     scope(input);

blockNumber=blockNumber+1;

end

% Plot something
figure;
pspectrum(wetSignal(:,1),fs,'spectrogram','OverlapPercent',0, ...
    'Leakage',1,'MinThreshold',-60, 'TimeResolution', 10e-3, 'FrequencyLimits',[20 20000]);

% linkaxes(ax1,ax2,ax3,'x');


% view(-45,65)
% colormap bone

% plotIt(sample, frequencies, thresholdBuffer); %Complex values are not supported.
heatmap(thresholdBuffer); %Complex values are not supported.

% Play file
soundsc(input,fs)


% Clean up
%     
% release(scope);
% scopeHandles.scope = scope;
   
%close(tuningUI)
clear HelperMultibandCompressionSim
clear HelperMultibandCompressionSim_mex
clear HelperUnpackUIData
 

