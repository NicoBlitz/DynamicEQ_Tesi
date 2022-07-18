

function plotIt(xArray,yArray,xAxis,yAxis,title)
hold on;

switch xAxis
    case 'log'
       semilogx(xArray, yArray, 'ko');
       xlabel(xAxis); ylabel(yAxis); %title('',title,' (',xAxis,' per ',yAxis,'');
       axis([min(xArray) max(xArray) min(yArray) max(yArray)]); %pause;

    case 'barks'
       plot(xArray, yArray, xAxis, yAxis, '-o');
       xlabel(xAxis); ylabel(yAxis); title('',title,' (',xAxis,' per ',yAxis,'');
       axis([min(xArray) max(xArray) min(yArray) max(yArray)]); %pause;


    case 'time'
       plot(xArray, yArray, xAxis, yAxis, '-o');
       xlabel(xAxis); ylabel(yAxis); title('',title,' (',xAxis,' per ',yAxis,'');
       axis([min(xArray) max(xArray) min(yArray) max(yArray)]); %pause;

end