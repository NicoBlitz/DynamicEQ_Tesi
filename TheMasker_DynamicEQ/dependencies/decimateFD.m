function decimated_signal = decimateFD(input, fbank, fs)

    %converting to mono
    input_mono = mean(input,2);

    %converting input signal to Frequency Domain
    input_decimated = fbank*abs(getFD(input_mono, fs));

    %convert amp to db
    %abs to avoid negative values
    %TODO: handle -inf cases
    decimated_signal = amp2db(input_decimated);
 
end