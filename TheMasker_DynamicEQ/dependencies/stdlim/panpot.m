function [ Y ] = panpot( X, a )
%PANPOT distributes a signal over 2 channels
%
%[ Y ] = PANPOT( X, a )
%
%   If X is a vector: returns a n-by-2 matrix with a panned version of X
%   If X is a n-by-2 matrix, rotates X rotated by a given angle
%   
%   a: panning or rotation angle
%      a = 0     -> left
%      a = pi/2  -> right
%      a = pi/4  -> mid
%      a = -pi/4 -> side
%
%(C)2018 G.Presti (LIM) - GPL license at the end of file
% See also ANG2MAT, FADE, MSMATRIX

    ch = size(X,2);
    switch ch
        case 1
        case 2
            a = [a, a+pi/2];
        otherwise
            error('This version only supports n-by-2 signals');
    end
    
    Y = (ang2mat(a) * X.').';
    
end

% ------------------------------------------------------------------------
%
% panpot.m: distributes a signal over 2 channels
% Copyright (C) 2018 - Giorgio Presti - Laboratorio di Informatica Musicale
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