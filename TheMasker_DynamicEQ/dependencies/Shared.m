
fs=44100;  % sampling frequency of audio signal
buffersize=4096;
nfft=buffersize/2;  %number of fft subbands
nfilts=32;  %number of subbands in the bark domain
nyquistFreq = fs/2; 

% Frequencies and barks
maxfreq=22000;
minfreq=20; 
maxbark=hz2bark(maxfreq);
minbark=hz2bark(minfreq);
step_bark = (maxbark-minbark)/(nfft-1);
barks=minbark:step_bark:maxbark;
frequencies=bark2hz(barks); % frequency (Hz) array (dimension 1 x nfft)
[ fbank, cent ] = getfbank( frequencies,'bark', nfilts, [], 'tri'); % Decimation filter bank
% fCenters=bark2hz(cent); % frequency (Hz) array (dimension 1 x nfilts)
fCenters = cent; % frequency (Hz) array (dimension 1 x nfilts)


% Spreading function
spread_exp=0.6;  % the higher the value, the lower the relative threshold, the higher the amount of "spreading"
spreadingfunctionmatrix = spreadingFunctionMatrix(maxfreq, nfilts, spread_exp);


%Absolute threshold in quiet variables
min_dbFS=-64; % minimum dBFS (used by ATQ)
ATQ_lift=1.6; % scales the ATQ: the higher the value, the higher the threshold in quiet

% Delta modulation variables
maxGainModule=20;
dGating_thresh = -40; % in dBFS
dGating_knee = 10; % in dB


% PeakEQFilter variables
myFilter_L = dsp.BiquadFilter( ...
    SOSMatrixSource="Input port", ...
    ScaleValuesInputPort=false);
myFilter_R = dsp.BiquadFilter( ...
    SOSMatrixSource="Input port", ...
    ScaleValuesInputPort=false);

filterOrder = 2;

% "Q" calculation (necessary for designParamEQ() )
octaves=(hz2st(maxfreq)-hz2st(minfreq))/12;
bw_oct=octaves/nfilts;
% Q=sqrt(2^(bw_oct))/(2^bw_oct-1)/2; %definire empiricamente

% Q(1)=4;
% Q= 2.7;
q_range=2;
q_min=0.4;
q_exp=0.4;
Q=(linspace(0,1,nfilts).^q_exp)*q_range+q_min;
% Frequency centers and bands normalized from 0 to 1, where 1 is nyquist frequency (necessary for designParamEQ() )
EQcent=fCenters/nyquistFreq;
EQband=zeros(1,nfilts);
for i=1:nfilts  
    EQband(i)=EQcent(i)/Q(i);
end



% Plot syle variables
wetStr = '#00a36d';
wetColor = sscanf(wetStr(2:end),'%2x%2x%2x',[1 3])/255;





