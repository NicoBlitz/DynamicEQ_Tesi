function deltaSignal = getDelta(inputSignal, threshold)

    deltaSignal = inputSignal - threshold;
    % clf('reset')
    %plot threshold and delta
    THplot = plot(linspace(1,length(threshold),length(threshold)) ,(threshold(:).'), 'red');
    hold on;
    INplot = plot(linspace(1,length(inputSignal),length(inputSignal)) ,(inputSignal(:).'), 'blue');
    hold on;
    Dplot = plot(linspace(1,length(deltaSignal),length(deltaSignal)) ,(deltaSignal(:).'), 'green');

end