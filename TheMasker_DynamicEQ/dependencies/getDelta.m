function deltaSignal = getDelta(inputSignal, threshold)
    
    deltaSignal = inputSignal - threshold;
    %plot threshold and delta
    clf('reset')
    
    hold on;
    THplot = plot(linspace(1,length(threshold),length(threshold)) ,(threshold(:).'), 'red');
    INplot = plot(linspace(1,length(inputSignal),length(inputSignal)) ,(inputSignal(:).'), 'blue');
    Dplot = plot(linspace(1,length(deltaSignal),length(deltaSignal)) ,(deltaSignal(:).'), 'green');
    hold off;
    legend({'threshold','input', 'delta'},'Location','best','Orientation','vertical');
    xlabel('frequency number');
    ylabel('dBFS');
    title('Threshold vs input vs delta');

end