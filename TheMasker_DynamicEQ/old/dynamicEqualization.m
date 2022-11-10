function [wetSignal,B,A] = dynamicEqualization(blockIN_Gain, threshold, fCenters, fbank, fs, SEP, EQcent, EQband, myFilter, filterOrders)

    %prepare input signal: FFT, Barks and amp2dB conversion
    inputSignal = decimateFD(blockIN_Gain, fbank, fs);

    %getting delta
    deltaSignal = inputSignal - threshold;

    %UI separation switch
    deltaSignal = deltaSignal*SEP;

    %apply delta on inputSignal (exp/comp)
%     processedSignal = processSignal(inputSignal, deltaSignal);
    
    %EQs
    %passiamo il segnale input originario 
    [equalizedSignal,B,A] = peakFilterEq(blockIN_Gain, deltaSignal, EQcent, EQband, myFilter, filterOrders);
    
    wetSignalFD = decimateFD(equalizedSignal, fbank, fs);
    
    gainReduction = wetSignalFD - inputSignal;

    frequencyNumbers = linspace(1,length(threshold),length(threshold));
%     frequencyNumbersTot = linspace(1,length(blockIN_Gain),length(blockIN_Gain));


    clf('reset')
    
    % Plot threshold and input (in FD) signal
    THplot= semilogx(fCenters, threshold, '--black');
    hold on;
    INplot= semilogx(fCenters, inputSignal, 'blue');
%   
    % Plot delta negative and positive.
    deltaPOSplot= bar(fCenters, max(deltaSignal,0), 'g', 'BarWidth', 1);
    deltaNEGplot= bar(fCenters, min(deltaSignal,0), 'm', 'BarWidth', 1);
    
    % Plot wet signal
    OUTplot= semilogx(fCenters, wetSignalFD, 'magenta');
    GRplot= semilogx(fCenters, gainReduction, 'red');

    hold off;

%     xlabel('frequency number');
%     ylabel('dBFS');
%     title('IN vs OUT');
%     legend({'threshold','input', 'delta +', 'delta -','wet'},'Location','best','Orientation','vertical');


    %---------------------------------------------------------------------
    wetSignal = equalizedSignal;


end