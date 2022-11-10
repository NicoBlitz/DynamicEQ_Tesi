function inputSignal = prepareInputSignal(blockIN_Gain, fbank, fs)

    %converting to mono
    blockIN_Gain = mean(blockIN_Gain,2);

    %converting input signal to Frequency Domain
    input_amp_ratio_barks = real(fbank*getFD(blockIN_Gain, fs));

    %convert amp to db
    %abs to avoid negative values
    %TODO: handle -inf cases
    inputSignal = amp2db(abs(input_amp_ratio_barks));
 
end