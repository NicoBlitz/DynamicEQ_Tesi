function wetSignal = dynamicEqualization(blockIN_Gain, threshold, nfft, fs, nfilts)
    
    %converting to Frequency Domain
    wetSignalFD = getFD(blockIN_Gain, fs);
    
    %converting from frquency to Barks
    %Based on https://stackoverflow.com/questions/10754549/fft-bin-width-clarification
    bin_width = fs / nfft;
    %questi valori di bins dove li abbiamo visti insieme?
    %sono giusti i valori da 0 a 256? o devono essere 512?
    bins=(0:bin_width:fs/2-1);
    
    %check thiiiiissssssss
    barkFilters = getfbank(bins, 'auto', 'bark', @triang, 32);

    %decimate (con barks non stiamo già decimando?)


    %---------------------------------------------------------------------
    %getting delta


    wetSignal = wetSignalFD;

end