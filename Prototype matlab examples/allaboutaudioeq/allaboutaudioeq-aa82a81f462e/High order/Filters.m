function [b a z p k] = Filters(N,filtertype,G,wc,B,Gb)
%Generate Nth order prototype filter
[kP,zP,pP]=CreatePrototype(N);

%Change to gain at cutoff or bandwidth set to Gb
[kLP,zLP,pLP]=ChangeCutoffGain(N,filtertype,G,Gb,kP,zP,pP);
%Now we have a prototype low pass filter, with absolute magnitude g at pi/2

switch filtertype
    case 'LP'
        [k,z,p]=ShiftCentre(N,wc,kLP,zLP,pLP);
    case 'LS'
        [k1,z1,p1]=CreateShelf(N,G,kLP,zLP,pLP);
        [k,z,p]=ShiftCentre(N,wc,k1,z1,p1);
    case 'HP'
        [k1,z1,p1]=InverseResponse(N,kLP,zLP,pLP);
        [k,z,p]=ShiftCentre(N,wc,k1,z1,p1);
    case 'HS'
        [k1,z1,p1]=CreateShelf(N,G,kLP,zLP,pLP);
        [k2,z2,p2]=InverseResponse(N,k1,z1,p1);
        [k,z,p]=ShiftCentre(N,wc,k2,z2,p2);
    case 'BP'
        [k1,z1,p1]=ShiftCentre(N,B,kLP,zLP,pLP);
        [k,z,p]=CreateBandpass(N,wc,k1,z1,p1);
    case 'BS'
        [k1,z1,p1]=InverseResponse(N,kLP,zLP,pLP);
        [k2,z2,p2]=ShiftCentre(N,B,k1,z1,p1);
        [k,z,p]=CreateBandpass(N,wc,k2,z2,p2);
    case 'PN' %Peak/notch filter from shifting a low shelving filter
        [k1,z1,p1]=CreateShelf(N,G,kLP,zLP,pLP);
        [k2,z2,p2]=ShiftCentre(N,B,k1,z1,p1);
        [k,z,p]=CreateBandpass(N,wc,k2,z2,p2);
    case 'OBS' %Out of band shelving filter from scaling a peaking/notch filter
        [k1,z1,p1]=CreateShelf(N,1/G,kLP,zLP,pLP);
        [k2,z2,p2]=ShiftCentre(N,B,k1,z1,p1);
        [k,z,p]=CreateBandpass(N,wc,k2,z2,p2);
     case 'OBS2' %Out of band shelving filter from shifting a high shelving filter
        [k1,z1,p1]=CreateShelf(N,G,kLP,zLP,pLP);
        [k2,z2,p2]=InverseResponse(N,k1,z1,p1);
        [k3,z3,p3]=ShiftCentre(N,B,k2,z2,p2);
        [k,z,p]=CreateBandpass(N,wc,k3,z3,p3);
    otherwise
        warning('Unexpected input.');
end
[b,a] = zp2tf(z',p',k);

