function equalizedSignal = filterBlock(originalSignal, delta, bandFreqs, fs)

    equalizedSignal = zeros(size(originalSignal,1),1);
    filter_order=4;
    nfilts=size(delta,1);


    for i=1:nfilts

        
        
        [z, p, k] = butter(filter_order, [bandFreqs(i,1) bandFreqs(i,2)], 'bandpass' ); 
%         d = designfilt('bandpassiir','FilterOrder',filter_order, ...
%         'HalfPowerFrequency1',bandFreqs(i,1)*(fs/2),'HalfPowerFrequency2',bandFreqs(i,2)*(fs/2), ...
%         'SampleRate',fs);
        sos = zp2sos(z,p,k);
        

        
        out= filtfilt(sos, db2amp(delta(i)), originalSignal);
%         out= filtfilt(d, originalSignal)*db2amp(delta(i));

        equalizedSignal = equalizedSignal + out;
        
%         fvt=fvtool(sos,d,'Fs',fs, 'FrequencyScale','log','Fs',fs );
%         legend(fvt,'butter', 'designfilt')
%         close(fvt);

    end
    

end
