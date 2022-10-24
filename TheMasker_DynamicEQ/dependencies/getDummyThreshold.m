function threshold = getDummyThreshold(nfilts)
    
    %random array[nfits] in dBFS
    %divided in 4 bands for more control
    for i=1:(nfilts)
        if (i<=(nfilts/4))
            threshold(i) = -600;
        elseif (i<=(nfilts/2))
            threshold(i) = -1200;
        elseif (i<=(nfilts*3/4))
            threshold(i) = -200;
        else
            threshold(i) = -500; 
    end
end