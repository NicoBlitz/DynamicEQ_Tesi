function  LTg = Global_masking_threshold(LTq, LTi)
%LTg = Global_masking_threshold(LTq, LTi, LTn)
%
%   Compute the global masking threshold for the subset of frequency lines 
%   defined in table [1, pp. 117]. It is the sum -- in the normal square
%   amplitude scale of the spectrum -- of the individual masking
%   thresholds and the absolute threshold [1, pp. 114].
%
%   See also Individual_masking_thresholds, Table_absolute_threshold
   
%   Author: Fabien A. P. Petitcolas
%           Computer Laboratory
%           University of Cambridge
%
%   Copyright (c) 1998--2001 by Fabien A. P. Petitcolas
%   $Header: /Matlab MPEG/Global_masking_threshold.m 3     7/07/01 1:27 Fabienpe $
%   $Id: Global_masking_threshold.m,v 1.3 1998-06-24 13:34:17+01 fapp2 Exp $

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

N = length(LTq(:, 1));
if not(isempty(LTi))
   m = length(LTi(:, 1));
end
%n = length(LTn(:, 1));
   
% The global masking thresholds is computing for the subset of frequencies
% defined in [1, Table 1.b]. They are the summ of the powers of the 
% corresponding to the individual masking thresholds (LTi, LTn) and the
% threshold in quiet (LTq).

for i = 1:N
   
   % Threshold in quiet
   temp = 10^(LTq(i) / 10);
   %temp=temp*0
   % Contribution of the tonal component
   if not(isempty(LTi))
	   for j = 1:m,
	      %temp = max(temp,10^(LTi(j, i) / 10));
          temp=max(temp,10^(LTi(j, i) / 10));
      end
   end
      
   % Contribution of the noise components
%    for j = 1:n,
%       temp = temp + 10^(LTn(j, i) / 10);
%    end
   
   LTg(i) = abs(10 * log10(temp));
end
