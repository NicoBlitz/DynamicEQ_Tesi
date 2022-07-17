

function plotIt(xAxis,yAxis)
   semilogx(xAxis, yAxis, xAxis, yAxis, 'ko');
   xlabel('Barks '); ylabel('dB'); title('Absolute threshold in quiet.');
   axis([min(xAxis) max(xAxis) min(yAxis) max(yAxis)]); %pause;
end