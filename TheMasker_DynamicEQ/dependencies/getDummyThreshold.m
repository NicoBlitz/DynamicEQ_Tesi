function threshold = getDummyThreshold(nfilts)
    
    %random array[nfits] in dBFS
    %divided in 4 bands for more control
    for i=1:(nfilts)
        if (i<=(nfilts/4))
            threshold(i) = -6;
        elseif (i<=(nfilts/2))
            threshold(i) = -12;
        elseif (i<=(nfilts*3/4))
            threshold(i) = -2;
        else
            threshold(i) = -5; 
    end
end