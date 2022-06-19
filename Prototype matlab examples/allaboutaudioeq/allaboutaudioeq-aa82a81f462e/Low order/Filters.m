function [b a] = Filters(filtertype,G,wc,B,Gc)
switch filtertype
    case 'LS'
        beta=tan(wc/2)*sqrt((Gc*Gc-1)/(G*G-Gc*Gc));
        b=[1+G*beta -1+G*beta];
        a=[1+beta -1+beta];
    case 'HS'
        beta=sqrt((Gc*Gc-1)/(G*G-Gc*Gc))/tan(wc/2);
        b=[1+G*beta 1-G*beta];
        a=[1+beta 1-beta];
    case 'PN'
        beta=tan(B/2)*sqrt((Gc*Gc-1)/(G*G-Gc*Gc));
        alpha=beta*(1+tan(wc/2)*tan(wc/2));
        b=[1+G*beta -2*cos(wc) 1-G*beta];
        a=[1+beta -2*cos(wc) 1-beta];
    otherwise
        warning('Unexpected input.');
end
