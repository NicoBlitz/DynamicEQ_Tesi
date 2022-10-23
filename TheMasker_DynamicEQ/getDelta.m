function deltaSignal = getDelta(inputSignal, threshold)

    deltaSignal = inputSignal - threshold;

    p = plot(linspace(1,length(deltaSignal),length(deltaSignal)) ,(deltaSignal(:).'));
    hold on;

end