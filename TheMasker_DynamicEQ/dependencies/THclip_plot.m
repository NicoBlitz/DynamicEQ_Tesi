

t = linspace(-80,0);
dGating_thresh = -40;
dGating_knee = 10;

th = (1+tanh((t-dGating_thresh)/dGating_knee))/2;
z = zeros(100)+0.5;

figure;
hold on
plot(t,th, 'color', [0.2, 0.6, 0.3], 'LineWidth', 2);
plot(t,z,'black');
hold off;
