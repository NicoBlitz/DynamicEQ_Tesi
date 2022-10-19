

function plotIt(xArray,yArray, extra)
% hold on;
    figure;
    dim=nargin;
    
    
    if(nargin==3 && isa(extra,'string'))
        dim=2;
    end

    if(nargin==2)
        dim=2;
        extra='';
    end
    
    if dim == 2 && strcmp(extra,'log')
       
            loglog(xArray, yArray);
            xlabel('freqs'); %title('',title,' (',xAxis,' per ',yAxis,'');
            axis([min(xArray)-1 max(xArray)+1 min(yArray)-1 max(yArray)+1]); %pause;

    elseif dim == 2 && strcmp(extra,'uniform') 
            plot((1:length(yArray)), yArray, 'ko');
            xlabel('uniform'); 
            axis([min(xArray)-1 max(xArray)+1 min(yArray)-1 max(yArray)+1]); 
    
    elseif dim == 2 && strcmp(extra,'')
            plot(xArray, yArray, 'b-');
            xlabel('samples'); 
            %axis([min(xArray)-1 max(xArray)+1 min(yArray) max(yArray)]); 

    elseif dim == 3 && not(isa(extra,'string'))
            heatmap(xArray, yArray, extra);
            %h.xlabel('undefined'); 
            %h.Aaxis([min(xArray)-1 max(xArray)+1 min(yArray)-1 max(yArray)+1]); 
    
       
    %     case 'time'
    %        plot(xArray, yArray, xAxis, yAxis, '-o');
    %        xlabel(xAxis); ylabel(yAxis); title('',title,' (',xAxis,' per ',yAxis,'');
    %        axis([min(xArray) max(xArray) min(yArray) max(yArray)]); %pause;
    
    end