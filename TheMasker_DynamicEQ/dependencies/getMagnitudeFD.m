function magnitude_dB = getMagnitudeFD(input, fs, fbank)

    %converting to mono
%     input_mono = mean(input,2);

    %converting input signal to Frequency Domain
    input_FD = abs(getFD(input, fs));

    if (nargin > 2) 
    input_FD = fbank*input_FD;
    end

    %convert amp to db
    %TODO: handle -inf cases
    magnitude_dB = amp2db(input_FD);
 
end