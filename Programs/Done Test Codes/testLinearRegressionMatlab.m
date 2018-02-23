% Demo to illustrate how to use the polyfit routine to fit data to a polynomial
% and to use polyval() to get estimated (fitted) data from the coefficients that polyfit() returns.
% Demo first uses a linear fit. 
% Reports the slope of the fitted line in the last 50 points.
% Initialization steps.
clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.)
clear;  % Erase all existing variables. Or clearvars if you want.
workspace;  % Make sure the workspace panel is showing.
format long g;
format compact;
fontSize = 20;
%============= LINEAR FIT ===================================
numberOfPoints = 100;
x = 1 : numberOfPoints; % Make numberOfPoints samples along the x axis
% Create a sample training set, a linear relation, with noise
% y is your actual data.  For this demo I'm going to simulate some noisy points along a line.
slope = 1.5;
intercept = -1;
noiseAmplitude = 15;
y = slope .* x + intercept + noiseAmplitude * rand(1, length(x));
% Now we have sample, noisy y values that we will fit a line through.
% Plot the training set of data (our noisy y values).
plot(x, y, 'ro', 'MarkerSize', 8, 'LineWidth', 2);
grid on;
xlabel('X', 'FontSize', fontSize);
ylabel('Y', 'FontSize', fontSize);
title('Linear Fit', 'FontSize', fontSize);
% Enlarge figure to full screen.
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
% Give a name to the title bar.
set(gcf, 'Name', 'Demo by ImageAnalyst', 'NumberTitle', 'Off') 
% Determine what points to use to fit to the last 50 points in the data.
firstIndex = numberOfPoints - 49;
lastIndex = numberOfPoints;
% Do the regression with polyfit.  Fit a straight line through the noisy y values.
[coefficients,S] = polyfit(x(firstIndex:lastIndex), y(firstIndex:lastIndex), 1);
% The x coefficient, slope, is coefficients(1).
% The constant, the intercept, is coefficients(2).
% Make fit.  It does NOT need to have the same
% number of elements as your training set, 
% or the same range, though it could if you want.
% Make 50 fitted samples going from firstIndex to lastIndex.
% Note: the number does not need to be the same number of points as your training data.
xFit = linspace(firstIndex, lastIndex, 50);
% Get the estimated values with polyval()
yFit = polyval(coefficients, xFit);
% Plot the fit
hold on;
plot(xFit, yFit, 'b.-', 'MarkerSize', 15, 'LineWidth', 1);
legend('Training Set', 'Fit', 'Location', 'Northwest');
slope = coefficients(1);
message = sprintf('The slope = %f', slope);
uiwait(helpdlg(message));