function wetSignal = dynamicEqualization(blockIN_Gain, threshold, fbank, fs, SEP)

    %prepare input signal: FFT, Barks and amp2dB conversion
    inputSignal = prepareInputSignal(blockIN_Gain, fbank, fs);

    %getting delta
    deltaSignal = getDelta(inputSignal, threshold);

    %UI separation switch
    deltaSignal = deltaSignal*SEP;

    %apply delta on inputSignal (exp/comp)
    processedSignal = processSignal(inputSignal, deltaSignal);
    
    %EQs
    %passiamo il segnale input originario 
    equalizedSignal = peakFilterEq(blockIN_Gain, deltaSignal);
    
    wetSignalFD = prepareInputSignal(equalizedSignal, fbank, fs);


    clf('reset')
    hold on;
    % Plot threshold and input (in FD) signal
    plot(linspace(1,length(threshold),length(threshold)) ,(threshold(:).'), 'red');
    plot(linspace(1,length(inputSignal),length(inputSignal)) ,(inputSignal(:).'), 'blue');
  
    % Plot delta negative and positive.
    bar((1:length(deltaSignal)), max(deltaSignal,0), 'g', 'BarWidth', 1)
    bar((1:length(deltaSignal)), min(deltaSignal,0), 'm', 'BarWidth', 1)
    
    % Plot wet signal
    plot(linspace(1,length(wetSignalFD),length(wetSignalFD)) ,(wetSignalFD(:).'), 'magenta');

    hold off;

%     xlabel('frequency number');
%     ylabel('dBFS');
%     title('Threshold vs input vs delta');


    
    xlabel('frequencies');
    ylabel('dBFS');
    legend({'threshold','input', 'delta +', 'delta -','wet'},'Location','best','Orientation','vertical');
    title('IN vs OUT ');

    %---------------------------------------------------------------------
    wetSignal = equalizedSignal;


end