function magnitude = getMagnitudeFD(input, fs, nfilts, freqs, fbank)

    numChannels=size(input,2);
    input_FD=zeros(length(input)/2,numChannels);
    input_FD_dec=zeros(nfilts,numChannels);
    if (nargin > 4) 
        magnitude=zeros(nfilts,numChannels);
    else
        magnitude=zeros(length(input)/2,numChannels);
    end

    for ch=1:numChannels

        input(:,ch)=input(:,ch).*hann(size(input, 1));

        %converting input signal to Frequency Domain
        input_FD(:,ch) = abs(getFD(input(:,ch), fs, freqs));
    
        if (nargin > 4) 
        input_FD_dec(:,ch) = fbank*input_FD(:,ch);
        magnitude(:,ch)=input_FD_dec(:,ch);
        else
        magnitude(:,ch)=input_FD(:,ch);

        end
            
    end

end