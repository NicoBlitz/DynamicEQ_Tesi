function [kLP,zLP,pLP]=ChangeCutoffGain(N,filtertype,G,Gb,kP,zP,pP)
%Set value of gain g, to be used at cutoff or bandwidth frequencies 
switch filtertype
    case {'LS','HS','PN','OBS','OBS2'}
        if G==1 %avoid division by zero if the filter does nothing
            g=1;
        else
            g=sqrt((Gb*Gb-1)/(G*G-1)); %This scales the gain at centre frequency to between 0 to 1, rather than between 1 to G
        end
    otherwise
        g=Gb;%No need to scale
end
% Now apply a shift so that |H(F(pi/2))|=|H(wg)|=g

tanw_2=(1/(g*g)-1)^(1/(2*N));
%wg=2*atan(tanw_2);
%a=(tan(wg/2)-1)/(tan(wg/2)+1);
a=(tanw_2-1)/(tanw_2+1);
kLP=kP;
for n=1:N, 
    zLP(n)=(a+zP(n))/(a*zP(n)+1);
    pLP(n)=(a+pP(n))/(a*pP(n)+1);
    kLP=kLP*(a*zP(n)+1)/(a*pP(n)+1);
end