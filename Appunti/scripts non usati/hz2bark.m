
function Brk = hz2bark(f)
    %      Usage: Bark=hz2bark(f)
    %     f    : (ndarray)    Array containing frequencies in Hz.
    %     Returns  :
    %     Brk  : (ndarray)    Array containing Bark scaled values.
    %     
    Brk = 6.*asinh(f./600) ;                                               
end
