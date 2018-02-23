% Generate some simple X value data, where each X is the X value starting from the
% lower left of the rectangle, in a clockwise fashion around the edges of
% rectangle.

X1(:,1) = 1:1:60; X2(:,1) = 1:1:60;
X3(:,1) = X1+1;
X4(:,1) = X1+1;

% Rotate the X vectors into rows. 

X1_r = X1(:)';   
X2_r = X2(:)';
X3_r = X3(:)';    
X4_r = X4(:)';

X = [X1_r; X2_r; X3_r; X4_r];
Y =[zeros(size(X1_r));      1+zeros(size(X2_r)); ...
    1+zeros(size(X3_r));    zeros(size(X4_r))];  

patch(X, Y, 'c');
axis equal;
xlim([0, 61]);
ylim([-2, 2]);
xlabel('Trial No');
