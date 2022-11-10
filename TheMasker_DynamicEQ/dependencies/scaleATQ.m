

function ATQ_scaled = scaleATQ(ATQ_decimated, UIatqWeight, ATQ_lift, min_dbFS)
  
    ATQ_scaled = ATQ_decimated * UIatqWeight * ATQ_lift; % Scale ATQ according to UI knob "CleanUp" and internal value ATQ_lift
    ATQ_scaled = ATQ_scaled + min_dbFS; % Lower ATQ so that minimum is at -96 dBFS
    ATQ_scaled = min(ATQ_scaled, 0); % Clip (highest values of) ATQ at 0 dB


end








 