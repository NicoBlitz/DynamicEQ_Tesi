

function curve_new = stereoLinkedProcess(curve, UI_sl)
    mono=mean(curve,2); 
    curve_new(:,1)=UI_sl*mono+(1-UI_sl)*curve(:,1); % StereoLinked modulation L
    curve_new(:,2)=UI_sl*mono+(1-UI_sl)*curve(:,2); %StereoLinked modulation R

end








 