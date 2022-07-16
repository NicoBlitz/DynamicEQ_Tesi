clear;

Shared;
% LTQ;


[absThresh,barks] = LTQ.AbsThresh(fs,nfilts);

semilogx(barks, absThresh, barks, absThresh, 'ko');
   %semilogx(f, TH(:,ATH), '-r', 'LineWidth', 2);

   xlabel('Barks '); ylabel('?'); title('Absolute threshold in quiet.');
   axis([min(barks) max(barks) min(absThresh) max(absThresh)]); %pause;


 