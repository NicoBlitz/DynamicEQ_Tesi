function [LTg , Delta] = getThreshold(audio,L, fs)

Common;

f = [1500 1700 1800 2000 10000 11000 12000 13000];
a = [   1    2    1   .5     2   1.5     3     1];
%t = 0:1/fs:1;
x = audio;

[TH, Map, LTq] = Table_absolute_threshold(1, fs, L/4); % Threshold in quiet
%CB = Table_critical_band_boundaries(1, fs);
%C = Table_analysis_window;

% Process the input vector x.
for OFFSET = 1:384:length(x) - 384;
   %S = [];

   %%% Psychoacoustic analysis.

	% Compute the FFT for time frequency conversion [1, pp. 110].
	[X , Delta] = FFT_Analysis(x, OFFSET, fs);
   
   % Determine the sound pressure level in each  subband [1, pp. 110].
   %Lsb = Sound_pressure_level(X, scf);
   
   % Find the tonal (sine like) and non-tonal (noise like) components
   % of the signal [1, pp. 111--113]
   local_maxima = Find_tonal_components(X, TH, Map);
 
   % Compute the individual masking thresholds [1, pp. 113--114]
   [LTi] = ...
      Individual_masking_thresholds(X, local_maxima, TH, Map);
   
   % Compute the global masking threshold [1, pp. 114]
   LTg = Global_masking_threshold(LTq, LTi);
   
%    if (DRAW)
%       disp('Global masking threshold');
%       hold on;
%       plot(TH(:, INDEX), LTg, 'k--');
%       hold off;
%       title('Masking components and masking thresholds.');
%    end
   
 
end



