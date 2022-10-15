

function plotIt(xArray,yArray, X_Mode, Y_Mode)
% hold on;


if(nargin<4)
    Y_Mode='?'
end

if(nargin<3)
    X_Mode='?'
end

switch X_Mode
    case 'log'
       loglog(xArray, yArray);
       xlabel(X_Mode); ylabel(Y_Mode); %title('',title,' (',xAxis,' per ',yAxis,'');
       axis([min(xArray)-1 max(xArray)+1 min(yArray)-1 max(yArray)+1]); %pause;
       
    case 'barks'
       plot(xArray, yArray, 'ko');
       xlabel('barks'); ylabel(Y_Mode); 
       axis([min(xArray)-1 max(xArray)+1 min(yArray)-1 max(yArray)+1]); 

    case 'uniform'
        plot((1:length(yArray)), yArray, 'ko');
        xlabel('uniform'); ylabel(Y_Mode); 
        axis([min(xArray)-1 max(xArray)+1 min(yArray)-1 max(yArray)+1]); 
%     case 'time'
%        plot(xArray, yArray, xAxis, yAxis, '-o');
%        xlabel(xAxis); ylabel(yAxis); title('',title,' (',xAxis,' per ',yAxis,'');
%        axis([min(xArray) max(xArray) min(yArray) max(yArray)]); %pause;

end