function filteredIN_Signal = prepareInputSignal(blockIN_Gain, nfft, fs, nfilts, frequencies)

    %converting to mono
    monoSignal = mean(blockIN_Gain,2);

    %converting input signal to Frequency Domain
    wetSignalFD = getFD(monoSignal, fs);

    %convert amp to db
    wetSignalFD = amp2db(wetSignalFD)

    %get filter banks (to bark, 32 val)
    filterBanks = getfbank(frequencies, 'auto', 'bark', @triang, nfilts);
    
    %filtered signal
    filteredIN_Signal = filterBanks*wetSignalFD;

end