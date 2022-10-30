function [r, rdB] = resp(b,a,f,sr)

    phi =  sin( (2 * pi * f) ./ (2 * sr) ).^2;
    sqphi = phi.^2;
    r = polinom(b, phi, sqphi) ./ polinom(a, phi, sqphi);
    r = sqrt(max(r,0));
    
    if nargout > 1
        rdB = amp2db(r);
    end

end

function pz = polinom(x, phi, sqphi)

    pz = ( 16*x(1)*x(3)*sqphi + (sum(x)^2) - 4*( x(1)*x(2) + 4*x(1)*x(3) + x(2)*x(3))*phi );

end