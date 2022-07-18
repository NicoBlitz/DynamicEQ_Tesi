function LTg = getThreshold(audio,L, fs)

Common;


x = audio;

[TH, Map, LTq] = Table_absolute_threshold(1, fs, 128); % Threshold in quiet


% Process the input vector x.
for OFFSET = 1:FFT_SHIFT:length(x) - FFT_SHIFT
%for OFFSET = 1:384:length(x) - 384;
   %S = [];

   %%% Psychoacoustic analysis.

	% Compute the FFT for time frequency conversion [1, pp. 110].
	[X , Delta] = FFT_Analysis(x, OFFSET);
    
   % Determine the sound pressure level in each  subband [1, pp. 110].
   %Lsb = Sound_pressure_level(X, scf);
   
   % Find the tonal (sine like) and non-tonal (noise like) components
   % of the signal [1, pp. 111--113]
   %local_maxima = Find_tonal_components(X, TH, Map);
 
   % Compute the individual masking thresholds [1, pp. 113--114]
   [LTi] = ...
   Individual_masking_thresholds(X, TH, Map);

   %X = X +  Delta;
   % Compute the global masking threshold [1, pp. 114]
   LTg = Global_masking_threshold(LTq, LTi);

  LTg = LTg - Delta;

end



