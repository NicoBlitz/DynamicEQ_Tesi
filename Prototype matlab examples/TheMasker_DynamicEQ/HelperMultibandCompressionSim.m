function audio = HelperMultibandCompressionSim(tuningUIStruct)
% HELPERMULTIBANDCOMPRESSIONSIM implements algorithm used in audio
% multiband dynamic range compression example. This function instantiates,
% initializes and steps through the System objects used in the algorithm.
% 
% You can tune the properties of the compressor bank through the UI that
% appears when multibandAudioCompressionExampleApp is executed.
%
% This function HelperMultibandCompressionSim is only in support of
% MultibandDynamicRangeCompressionExample. It may change in a future
% release.

%   Copyright 2013-2018 The MathWorks, Inc.

%#codegen

% Instantiate and initialize System objects. The objects are declared
% persistent so that they are not recreated every time the function is
% called inside the simulation loop. 
Common;

persistent reader readerSC drc1 drc2 drc3 drc4 masker crossover player 
masker = 0.0;

if isempty(reader)
    Fs = SAMPLE_RATE;
    % audio I/O
    reader = dsp.AudioFileReader('Filename','RockGuitar-16-44p1-stereo-72secs.wav', ...
        'PlayCount',Inf,'SamplesPerFrame',512);
    readerSC = dsp.AudioFileReader('Filename','audio\Michael Bublé - Feeling Good [Official Music Video].wav', ...
       'PlayCount',Inf,'SamplesPerFrame',512);
    player = audioDeviceWriter('SampleRate',Fs);
    % Compressor bank                            
    drc1 = compressor('SampleRate',Fs, ...
                      'Ratio',5, ...
                      'Threshold',-5, ...
                      'KneeWidth',5, ...
                      'AttackTime',5e-3, ...
                      'ReleaseTime',1e-1);
    drc2 = compressor('SampleRate',Fs, ...
                      'Ratio',5, ...
                      'Threshold',-10, ...
                      'KneeWidth',5, ...
                      'AttackTime',5e-3, ...
                      'ReleaseTime',1e-1);
    drc3 = compressor('SampleRate',Fs, ...
                      'Ratio',5, ...
                      'Threshold',-20, ...
                      'KneeWidth',5, ...
                      'AttackTime',2e-3, ...
                      'ReleaseTime',50-3);
    drc4 = compressor('SampleRate',Fs, ...
                      'Ratio',4, ...
                      'Threshold',-30, ...
                      'KneeWidth',5, ...
                      'AttackTime',2e-3, ...
                      'ReleaseTime',50e-3);
    % Multiband crossover filter                                             
    crossover = crossoverFilter(3,[120 1e3 3e3],18,'SampleRate',Fs);

    
    
   
end

if tuningUIStruct.ValuesChanged
    paramNew = tuningUIStruct.TuningValues;
    drc1.Ratio       = paramNew(1);
    drc1.Threshold   = paramNew(2);
    drc1.AttackTime  = paramNew(3);
    drc1.ReleaseTime = paramNew(4);
    
    drc2.Ratio       = paramNew(5);
    drc2.Threshold   = paramNew(6);
    drc2.AttackTime  = paramNew(7);
    drc2.ReleaseTime = paramNew(8);
    
    drc3.Ratio       = paramNew(9);
    drc3.Threshold   = paramNew(10);
    drc3.AttackTime  = paramNew(11);
    drc3.ReleaseTime = paramNew(12);
    
    drc4.Ratio       = paramNew(13);
    drc4.Threshold   = paramNew(14);  %wewe
    drc4.AttackTime  = paramNew(15);
    drc4.ReleaseTime = paramNew(16);

    %masker = paramNew(17);

end

%drc4.Threshold   = drc4.Threshold*inputSample;  %%wewe
%masker = param(17);

if tuningUIStruct.Reset % reset System object
    reset(reader);
    reset(readerSC);
    reset(drc1);
    reset(drc2);
    reset(drc3);
    reset(drc4);
    reset(masker);
    reset(crossover);
    reset(player);
end

% Read audio from file
x = reader();
SC = readerSC();


% Split into 4 bands
[a10,a20,a30,a40] = crossover(x);
[sc10,sc20,sc30,sc40] = crossover(SC);




% Compress
a1 = drc1(a10);
a2 = drc2(a20);
a3 = drc3(a30);
a4 = drc4(a40);

%fprintf("%s \n",sc10);

sc1 = sc10-masker;
sc2 = sc20-masker;
sc3 = sc30-masker;
sc4 = sc40-masker;


%mask = SC - masker;



% New audio output

%audioOut = a1 + a2 + a3 +  a4;
%audioIn = a10 + a20 + a30 + a40;
%mask = sc1+sc2+sc3+sc4;

audio = SC;
%audio = [audioIn(:,1), audioOut(:,1), mask(:,1)];

% Play audio
player(SC);