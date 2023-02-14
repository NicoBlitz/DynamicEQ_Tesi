function delta_clipped = scaleDelta(delta_mod, threshold, dGating_thresh, dGating_knee)
    THclip = (1+tanh((threshold-dGating_thresh)/dGating_knee))/2;
    delta_clipped = delta_mod .* THclip;
end








 