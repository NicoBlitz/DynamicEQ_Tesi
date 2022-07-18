function mTbark = maskingThresholdBark(mXbark,spreadingfuncmatrix,alpha_exp)
     %Computes the masking threshold on the Bark scale with non-linear superposition
     %usage: mTbark=maskingThresholdBark(mXbark,spreadingfuncmatrix,alpha_exp)
     %Arg: mXbark: magnitude of FFT spectrum,
     %spreadingfuncmatrix: spreading function matrix from function spreadingfunctionmat
     %alpha_exp: exponent for non-linear superposition (eg. 0.6)
     %return: masking threshold as "voltage" on Bark scale
    
     %mXbark: is the magnitude-spectrum mapped to the Bark scale,
     %mTbark: is the resulting Masking Threshold in the Bark scale, whose components are
     %sqrt(I_tk) on page 13.
    
     mTbark=(mXbark.^alpha_exp)*spreadingfuncmatrix;
     %apply the inverse exponent to the result:
    
     mTbark=mTbark.^(1.0/alpha_exp);
     

end
