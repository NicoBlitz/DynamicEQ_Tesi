function [X, Delta]  = FFT_Analysis(Input, n)
%X = FFT_Analysis(Input, n)
%
%   Compute the auditory spectrum using the Fast Fourier Transform.
%   The spectrum X is expressed in dB. The size of the transform si 512 and
%   is centered on the 384 samples (12 samples per subband) used for the 
%   subband analysis. The first of the 384 samples is indexed by n:
%   ................................................
%      |       |  384 samples    |        |
%      n-64    n                 n+383    n+447
%
%   A Hanning window applied before computing the FFT.
%
%   Finaly, a normalisation  of the sound pressure level is done such that
%   the maximum value of the spectrum is 96dB; the number of dB added is 
%   stored in Delta output.
%
%   One should take care that the Input is not zero at all samples.
%   Otherwise W will be -INF for all samples.
   
%   Author: Fabien A. P. Petitcolas
%           Computer Laboratory
%           University of Cambridge
%
%   Copyright (c) 1998--2001 by Fabien A. P. Petitcolas
%   $Header: /Matlab MPEG/FFT_Analysis.m 3     7/07/01 1:27 Fabienpe $
%   $Id: FFT_Analysis.m,v 1.4 1998-07-08 11:29:26+01 fapp2 Exp $

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
Shared;



% Check input parameters
% N=nfft*2;

% Prepare the samples used for the FFT
% Add zero padding if samples are missing
%  s = Input(max(1, n):min(N, n+nfft-fftOverlap-1)); 
s=Input() %(1:Input.length)
s_mono=zeros(length(s)).';
s=s(1)+s(2)
%  s = s(:);

% if (n - fftOverlap < 1)
%    s = [zeros(fftOverlap - n + 1, 1); s];
% end
% if (N < n - fftOverlap + nfft - 1)
%    s = [s; zeros(n - fftOverlap + nfft - 1 - N, 1)];
% end

% Prepare the Hanning window
h = sqrt(8/3) * hanning(nfft, 'periodic');


% Power density spectrum

% magxF=fftshift(sx);
% f_inicial = -(Fs/2);
% f_final = (Fs/2) - df;
% freq = f_inicial:df:f_final;



X = max(20 *log10(abs(fft(s.*h))/ nfft), min_power);

      

       
% Normalization to the reference sound pressure level of 96 dB
Delta = 96;
%- max(X);

