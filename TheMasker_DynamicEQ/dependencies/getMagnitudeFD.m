function magnitude_dB = getMagnitudeFD(input, fs, nfilts, fbank)

    numChannels=size(input,2);
    input_FD=zeros(length(input)/2,1);
    input_FD_dec=zeros(nfilts,1);

    for ch=1:numChannels

        %converting input signal to Frequency Domain
        input_FD(:,ch) = abs(getFD(input(:,ch), fs));
    
        if (nargin > 3) 
        input_FD_dec(:,ch) = fbank*input_FD(:,ch);
        magnitude_dB(:,ch) = amp2db(input_FD_dec(:,ch));
        else
        magnitude_dB(:,ch) = amp2db(input_FD(:,ch));
    
        end
    
        %convert amp to db
        
    end
end