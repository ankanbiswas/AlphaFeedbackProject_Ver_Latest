clear all;

% Generate some simple X value data, where each X is the X value starting from the
% lower left of the rectangle, in a clockwise fashion around the edges of
% rectangle.
X1(:,1) = 0:10:100;
X2(:,1) = 0:10:100;
X3(:,1) = X1+2;
X4(:,1) = X1+2;

% Rotate the X vectors into rows. 
X1 = X1(:)';   
X2 = X2(:)';
X3 = X3(:)';    
X4 = X4(:)';

% Here I am stacking each X on top of each other, and padding the bottom
% row with NaNs.  Adding a similar Y set of values, which will simply be a
% height of 0-10
X =[X1; X2; X3; X4; 
    nan(size(X1))   ];
Y =[zeros(size(X1));        10+zeros(size(X2)); ...
    10+zeros(size(X3));     zeros(size(X4));     
    nan(size(X1))  ];


% Rotate vectors so that the last value in the X/Y coordinates is a NaN,
% and Matlab will ignore and plot the next value
X=X(:);
Y=Y(:);

% This Plots the outline of the rectangles I am looking for, with a width
% of 2, height of 10, starting at each 10th value of X
p=patch( X ,Y,'c');
p.EdgeColor = 'b';  %Comment this out to see that the Patch function is not working?
p.FaceColor = 'blue';
p.FaceAlpha = 0.5;