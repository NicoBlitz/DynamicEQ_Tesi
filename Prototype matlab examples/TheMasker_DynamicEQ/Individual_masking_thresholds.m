function  LTi = Individual_masking_thresholds(X, TH, Map)
%[LTi, LTn] = Individual_masking_thresholds(X, local_maxima, ...
%   Non_local_maxima, TH, Map)
%
%   Compute the masking effect of both tonal and non_tonal components on
%   the neighbouring spectral frequencies [1, pp. 113]. The strength os the
%   masker is summed with the masking index and the masking function.
   
%   Author: Fabien A. P. Petitcolas
%           Computer Laboratory
%           University of Cambridge
%
%   Copyright (c) 1998--2001 by Fabien A. P. Petitcolas
%   $Header: /Matlab MPEG/Individual_masking_thresholds.m 4     18/07/02 14:38 Fabienpe $
%   $Id: Individual_masking_thresholds.m,v 1.3 1998-06-24 13:34:17+01 fapp2 Exp $

%   References:
%    [1] Information technology -- Coding of moving pictures and associated
%        audio for digital storage media at up to 1,5 Mbits/s -- Part3: audio.
%        British standard. BSI, London. October 1993. Implementation of ISO/IEC
%        11172-3:1993. BSI, London. First edition 1993-08-01.
%
%   Legal notice:
%    This computer program is based on ISO/IEC 11172-3:1993, Information
%    technology -- Coding of moving pictures and associated audio for digital
%    storage media at up to about 1,5 Mbit/s -- Part 3: Audio, with the
%    permission of ISO. Copies of this standards can be purchased from the
%    British Standards Institution, 389 Chiswick High Road, GB-London W4 4AL, 
%    Telephone:+ 44 181 996 90 00, Telefax:+ 44 181 996 74 00 or from ISO,
%    postal box 56, CH-1211 Geneva 20, Telephone +41 22 749 0111, Telefax
%    +4122 734 1079. Copyright remains with ISO.
%-------------------------------------------------------------------------------
Common;

% Individual masking thresholds for both tonal and non-tonal 
% components are set to -infinity since the masking function has
% infinite attenuation beyond -3 and +8 barks, that is the component
% has no masking effect on frequencies beyond thos ranges [1, pp. 113--114]

% Check input parameters
if (length(X) ~= FFT_SIZE)
   error('Unexpected power density spectrum size.');
end

if (DRAW),
   t = 1:length(X);
end

local_maxima = [];
counter = 1;
for k = 2: FFT_SIZE/2 - 1 % Don't care about the borders
       %if (X(k) > X(k-1) & X(k) >= X(k+1) & k > 2 & k <= 250)
   
      local_maxima(counter, INDEX) = k;
      local_maxima(counter, SPL) = X(k);
      counter = counter + 1;
   
end

% if (DRAW)
%    disp('Local maxima.');
%    plot(t, X(t), local_maxima(:, INDEX), local_maxima(:, SPL), 'ko');
%    xlabel('Frequency index'); ylabel('dB'); title('Local maxima.');
%    axis([0 256 0 100]); pause;
% end



if isempty(local_maxima)
   LTi = [];
else
   LTi = zeros(length(local_maxima(:, 1)), length(TH(:, 1))) + MIN_POWER;
end


% Only a subset of the samples are considered for the calculation of
% the global masking threshold. The number of these samples depends
% on the sampling rate and the encoding layer. All the information
% needed is in TH which contains the frequencies, critical band rates
% and absolute threshold.
for i = 1:length(TH(:, 1))
   zi = TH(i, BARK);  % Critical band rate of the frequency considered   
   
   if not(isempty(local_maxima))
	   % For each tonal component
	   for k = 1:length(local_maxima(:, 1)),
	      j  = local_maxima(k, INDEX);
	      zj = TH(Map(j), BARK); % Critical band rate of the masker
	      dz = zi - zj;          % Distance in Bark to the masker
	      
	      if (dz >= -3 & dz < 8)
	         
	         % Masking index
	         avtm = -1.525 - 0.275 * zj - 4.5;
	         
	         % Masking function
	         if (-3 <= dz & dz < -1)
	            vf = 17 * (dz + 1) - (0.4 * X(j) + 6);
	         elseif (-1 <= dz & dz < 0)
	            vf = (0.4 * X(j) + 6) * dz;
	         elseif (0 <= dz & dz < 1)
	            vf = -17 * dz;
	         elseif (1 <= dz & dz < 8)
	            vf = - (dz - 1) * (17 - 0.15 * X(j)) - 17;
	         end
         
	         LTi(k, i) = local_maxima(k, SPL) + avtm + vf;
	      end
      end
   end
end

% Add the individual masking thresholds to the existing graph
if (DRAW)
  if not(isempty(local_maxima))
 		hold on;
 	    for j = 1:length(local_maxima(:, 1))
	   	    plot(TH(:, INDEX), LTi(j, :), 'r:');
	    end
	   disp('Masking threshold for tonal components.');
      pause;
   end
end
