function deltaSignal = getDelta(inputSignal, threshold)
    
    deltaSignal = inputSignal - threshold;
    %plot threshold and delta
    
    clf('reset')
    hold on;
    plot(linspace(1,length(threshold),length(threshold)) ,(threshold(:).'), 'red');
    plot(linspace(1,length(inputSignal),length(inputSignal)) ,(inputSignal(:).'), 'blue');
  
    % Plot delta negative and positive.
    bar((1:length(deltaSignal)), max(deltaSignal,0), 'g', 'BarWidth', 1)
    bar((1:length(deltaSignal)), min(deltaSignal,0), 'm', 'BarWidth', 1)
    hold off;

    xlabel('frequency number');
    ylabel('dBFS');
    title('Threshold vs input vs delta');

end