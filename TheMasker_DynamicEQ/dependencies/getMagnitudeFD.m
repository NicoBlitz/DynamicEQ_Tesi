function magnitude_dB = getMagnitudeFD(input, fs, fbank)

    %converting to mono
    input_mono = mean(input,2);

    %converting input signal to Frequency Domain
    input_mono_FD = abs(getFD(input_mono, fs));

    if (nargin > 2) 
    input_mono_FD = fbank*input_mono_FD;
    end

    %convert amp to db
    %TODO: handle -inf cases
    magnitude_dB = amp2db(input_mono_FD);
 
end