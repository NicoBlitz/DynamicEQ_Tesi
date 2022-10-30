function processedSignal = processSignal(inputSignal, deltaSignal)

    %TODO: Bring in Shared
    ExpAmount = 1;
    CompAmount = 1;

    %Exp/Comp depending on delta
    %TODO: hadle attack and release? maybe not on Matlab :)
    for band=1:length(deltaSignal)
        d = deltaSignal(band);
        in = inputSignal(band);
        if(d>0)
            in = in + d * ExpAmount;
        end
        if(d<0)
            in = in + d * CompAmount;
        end
        processedSignal(band) = in;
    end
    
    clf('reset')
    hold on;
    plot(linspace(1,length(inputSignal),length(inputSignal)) ,(inputSignal(:).'), 'blue');
    plot(linspace(1,length(processedSignal),length(processedSignal)) ,(processedSignal(:).'), 'green');
   

    hold off;

    xlabel('frequencies');
    ylabel('dBFS');
    legend({'inputSignal','wetSignal'}, 'Location','best','Orientation','vertical')
    title('IN vs OUT ');



end