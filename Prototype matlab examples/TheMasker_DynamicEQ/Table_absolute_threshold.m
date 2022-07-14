function [TH, Map, LTq] = Table_absolute_threshold(Layer, fs, bitrate)
%[TH, Map,  LTq] = Table_absolute_threshold(Layer, fs, bitrate)
%
%   Returns the frequencies, critical band rates and absolute threshold
%   in TH. Map contais a mapping beween the frequency line k and an index
%   number for the TH or LTq tables. LTq contains only the threshold in quiet
%   LT_q(k) defined in tables D.1x of the standard [1, pp. 117].
%   
%   These values depends on the Layer, the frequency rate fs (H)z and the
%   bit rate `bitrate' kbits/s.
%
%   Conversion of the frequency f into barks is done using (f * bitrate / fs)
   
%   Author: Fabien A. P. Petitcolas
%           Computer Laboratory
%           University of Cambridge
%
%   Copyright (c) 1998--2001 by Fabien A. P. Petitcolas
%   $Header: /Matlab MPEG/Table_absolute_threshold.m 3     7/07/01 1:27 Fabienpe $
%   $Id: Table_absolute_threshold.m,v 1.2 1998-06-22 17:47:56+01 fapp2 Exp $

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

if (Layer == 1)
   if (fs == SAMPLE_RATE)
      
      
      N = length(TH(:, 1));
      
      % Convert frequencies to samples indecies.
         for i = 1:N,
         THmap(i, INDEX) = ceil(TH(i, FREQS) * FFT_SIZE / SAMPLE_RATE );
      end
      
      % Generate a mapping between the FFT_SIZE / 2 samples of the input
      % signal and the N coefficients of the absolute threshold table.

      % Borders
      for j = 1:THmap(1, INDEX),
         Map(j) = 1;
      end
      for j = THmap(N, INDEX):FFT_SIZE/2,
         Map(j) = N;
      end
      % All the other (from table)
      for i = 2:N-1,
         for j = THmap(i, INDEX):THmap(N, INDEX)-1,
            Map(j) = i;
         end
      end
      
      % An offset depending on the overall bit rate is used for the absolute
      % threshold. This offset is -12dB for bit rates >=- 96kbits/s and 0dB
      % for bit rates < 96 kbits/s per channel. [1, pp. 111]
%       if (bitrate >= 96)
         for i = 1:N,
            TH(i, ATH) = TH(i, ATH) - 12;
         end
%       end
      
      LTq = TH(:, ATH);
   else
      error('Frequency not supported.');
   end
else
   error('Layer not supported.');
end