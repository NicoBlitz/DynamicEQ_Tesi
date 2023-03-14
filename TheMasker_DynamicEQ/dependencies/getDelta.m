function [delta, threshold, in_dB] = getDelta(blockSC_Gain, blockIN_Gain, ATQ_scaled, fs, fbank, spreadingFunctionMatrix, freqs)
    numChannels=size(blockSC_Gain,2);
    nfilts=size(fbank,1);
    %amplitude_ratio_barks=zeros(size(fbank,1),numChannels);
    input = zeros(size(fbank,2),numChannels);
    sidechain = zeros(size(fbank,2),numChannels);
    in_dB = zeros(nfilts,numChannels);
    sc_dB = zeros(nfilts,numChannels);
    threshold = zeros(nfilts,numChannels);
    delta = zeros(nfilts,numChannels);

    %get input and sc in Frequency Domain (also decimate)
    input = getMagnitudeFD(blockIN_Gain, fs, nfilts, freqs, fbank);
    sidechain = getMagnitudeFD(blockSC_Gain, fs, nfilts, freqs, fbank);

    for ch=1:numChannels        
        

        % "Spread" the threshold
        sc_dB(:,ch)=spreadingFunctionMatrix*sidechain(:,ch);
    
        sc_dB(:,ch) = amp2db(sc_dB(:,ch));
        in_dB(:,ch) = amp2db(input(:,ch));

        % Convert to dB
        %relative_threshold(:,ch) = real(amp2db(relative_threshold(:,ch)));

        threshold(:,ch) = max(sc_dB(:,ch), ATQ_scaled);
        delta(:,ch) = in_dB(:,ch) - threshold(:,ch);



    end  



end