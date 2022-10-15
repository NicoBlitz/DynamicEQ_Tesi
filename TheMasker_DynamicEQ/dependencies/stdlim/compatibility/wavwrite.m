function wavwrite( y, Fs, N, filename )
%WAVWRITE (backward compatibility for wavwrite)
%
% WAVWRITE(y,'filename')
% WAVWRITE(y,Fs,'filename')
% WAVWRITE(y,Fs,N,'filename')
%
%	audiowrite wrapper for wavwrite backward compatibility
%
%(C)2014 G.Presti (LIM) - GPL license at the end of file
% See also WAVREAD, AUDIOWRITE, AUDIOREAD

	switch nargin
		case 2
			filename = Fs;
			Fs = 8000;
			N = 16;
		case 3
			filename = N;
			N = 16;
        otherwise
	end

	audiowrite(filename,y,Fs,'BitsPerSample',N);

end

% ------------------------------------------------------------------------
%
% wavwrite.m: backward compatibility for wavwrite
% Copyright (C) 2014 - Giorgio Presti - Laboratorio di Informatica Musicale
% 
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>
%
% ------------------------------------------------------------------------