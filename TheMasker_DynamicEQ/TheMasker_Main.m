
close all;
bdclose all

% Creates Absolute Threshold in quiet and other constant variables
Shared;

% Read entire files
[input,fs] = audioread("audio\Michael Buble edit.wav");
[scInput,fs] = audioread("audio\Michael Buble edit.wav");

% PREPARE TO PLAY

% Create tuning UI 
param = struct([]);

UIinGain = 0.8;
UIscGain = 0.8;

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


% Create 1 matlab figure
figure;


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


S = HelperUnpackUIData(tuningUI);


% PROCESS BLOCK

% Execute algorithm from first to last sample of the file with a step of nfft*2 

for offset = 1:buffersize:length(input)-buffersize

    
blockSC = scInput(offset:offset+buffersize-1,:);
blockIN = input(offset:offset+buffersize-1,:);   

blockIN_Gain = blockIN * UIinGain;
blockSC_Gain = blockSC * UIscGain;

% Calculate block's threshold depending on our psychoacoustic model  
% nfilts already exist in Shared - where ATQ and spreadingFunction are calculated 
threshold = psychoAcousticAnalysis(blockSC_Gain, nfft, fs, fftoverlap);

% Signal processing depending on the threshold just calculated
% wetSignal = dynamicEqualization(blockIN_Gain, threshold, nfft, nfilts);

                
    %[X,Delta] = FFT_Analysis(input,nfft,min_power);
    
    %maskThreshold = maskingThreshold(X, W, W_inv,fs,spreadingfuncmatrix,alpha_exp,nfft,ATQ_current,barks,frequencies);
    
    %plotIt(frequencies,maskThreshold,'log','dB','mX');

    %maskThreshold = maskThreshold - Delta;

    %upperMask = [frequencies.', maskThreshold.'];

    %set(scope.SpectralMask,UpperMask=upperMask);
    
    % Visualize results
    


%     audio = HelperMultibandCompressionSim(S,nfft,fs,samples);
%     scope(input);

end

% Play file
soundsc(input,fs)


% Clean up
%     
% release(scope);
% scopeHandles.scope = scope;
   
close(tuningUI)
clear HelperMultibandCompressionSim
clear HelperMultibandCompressionSim_mex
clear HelperUnpackUIData
 

