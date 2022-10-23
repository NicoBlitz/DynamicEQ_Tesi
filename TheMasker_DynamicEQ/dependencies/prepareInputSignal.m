function filteredIN_Signal = prepareInputSignal(blockIN_Gain, nfft, fs, nfilts, frequencies)

    %converting to mono
    monoSignal = mean(blockIN_Gain,2);

    %converting input signal to Frequency Domain
    wetSignalFD = getFD(monoSignal, fs);
    
    %get only real value (xxxi values exist due to an offset? ) 
    realwetSignalFD = real(wetSignalFD);

    %convert amp to db
    %abs to avoid negative values
    %TODO: handle -inf cases
    realwetSignalFD = amp2db(abs(realwetSignalFD));

    %get filter banks (to bark, 32 val)
    filterBanks = getfbank(frequencies, 'auto', 'bark', @triang, nfilts);
    
    %filtered signal
    filteredIN_Signal = filterBanks*realwetSignalFD;

end