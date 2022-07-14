function local_max_list = ...
   Find_tonal_components(X, TH, Map) % assume fs = 44100 fs
%[Flags, Tonal_list, Non_tonal_list] = Find_tonal_components(X, TH, Map, CB)
%
%   Identifie and list both tonal and non-tonal components of the audio
%   signal. It is assume in this implementation that the frequency
%   sampling fs is 44100 Hz. Details bare given in [1, pp. 112].
%
%   See also Decimation
   
%   Author: Fabien A. P. Petitcolas
%           Computer Laboratory
%           University of Cambridge
%
%   Copyright (c) 1998--2003 by Fabien A. P. Petitcolas
%   Find_tonal_components.m
%   Last modified: 11 August 2003

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

% Check input parameters
if (length(X) ~= FFT_SIZE)
   error('Unexpected power density spectrum size.');
end

if (DRAW),
   t = 1:length(X);
end

% List of flags for all the frequency lines (1 to FFT_SIZE / 2)
Flags = zeros(FFT_SIZE / 2, 1) + NOT_EXAMINED;

% Label the local maxima

% if (DRAW),
%    disp('Local maxima.');
%    plot(t, X(t), local_max_list(:, INDEX), local_max_list(:, SPL), 'ko');
%    xlabel('Frequency index'); ylabel('dB'); title('Local maxima.');
%    axis([0 256 0 100]); %pause;
% end

