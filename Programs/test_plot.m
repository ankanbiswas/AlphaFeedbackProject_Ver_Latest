N = 20;
x = linspace(0, 2*pi, N);   % Create Data
y = sin(x).^2;              % Create Data
erbar = randn(1, N);        % Create Error Bars
figure(1)
plot(x, y)
hold on
plot([x; x], [y-erbar; y+erbar], '-r')
hold off
grid