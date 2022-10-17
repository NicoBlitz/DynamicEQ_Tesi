
close all;
%bdclose all

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

for offset = 1:buffersize:length(input)-buffersize

    
blockSC = scInput(offset:offset+buffersize-1,:);
blockIN = input(offset:offset+buffersize-1,:);   

blockIN_Gain = blockIN * UIinGain;
blockSC_Gain = blockSC * UIscGain;

% Calculate block's threshold depending on our psychoacoustic model  
% nfilts already exist in Shared - where ATQ and spreadingFunction are calculated 
threshold = psychoAcousticAnalysis(blockSC_Gain, nfft, fs, fftoverlap);

%threshold = getDummyThreshold();

% Signal processing depending on the threshold just calculated
wetSignal = dynamicEqualization(blockIN_Gain, threshold, nfft, fs, nfilts, frequencies);

                
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
   
%close(tuningUI)
clear HelperMultibandCompressionSim
clear HelperMultibandCompressionSim_mex
clear HelperUnpackUIData
 

