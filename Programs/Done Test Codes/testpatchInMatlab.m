% This test function explores the usability of the patch fucntion in matlab

%% Section One: Example one
% 'https://in.mathworks.com/matlabcentral/answers/158482-faster-way-to-create-rectangles'
figure(2);
t = table([2 3 5; 2 3 5; 5 7 8; 5 7 8],[1 10 15; 2 11 16; 2 11 16; 1 10 15], ones(4,3),...
          'VariableNames',{'Xdata','Ydata','Zdata'},'RowNames',{'A','B','C','D'});
      
% Plot patch
patch(t.Xdata,t.Ydata,t.Zdata)
% (optional for clarity)
axis([0 10 0 20])
text(t.Xdata(:),t.Ydata(:),repmat(t.Properties.RowNames,3,1),'Color','red');

%% Section three: Example three 

% Generate some simple X value data, where each X is the X value starting from the
% lower left of the rectangle, in a clockwise fashion around the edges of
% rectangle.
X1(:,1) = 0:10:100;
X2(:,1) = 0:10:100;
X3(:,1) = X1+1;
X4(:,1) = X1+1;
% 
% Rotate the X vectors into rows. 
X1 = X1(:)';   
X2 = X2(:)';
X3 = X3(:)';    
X4 = X4(:)';

X = [X1; X2; X3; X4];
Y =[zeros(size(X1));        10+zeros(size(X2)); ...
    10+zeros(size(X3));     zeros(size(X4))];  

patch(X, Y, 'c');
clf
clear 


%% Section three: example three

x = [0:10:100; (0:10:100)+2];
X = reshape(repelem(x(:),2),4,[]);
Y = repmat([0; 10; 10; 0],1,size(X,2));
p = patch(X,Y,'b','EdgeColor','c', 'FaceAlpha', 0.5);

%% Section four: example four
% for creating objects (like box)
% the handle would have so many proproperties.
% after traking the handle, set the handle to give it new property value:
% h = patch();
% set(h,'propertyname',newpropertyvalue,..);
% get(h,'propertyname',newpropertyvalue,.._;

% there are two different ways to use patch:
% patch(x,y,c) or patch(x,y,z,c);

% This Plots the outline of the rectangles I am looking for, with a width
% of 2, height of 10, starting at each 10th value of X
% p=patch( X ,Y,'c');
% p.EdgeColor = 'b';  %Comment this out to see that the Patch function is not working?
% p.FaceColor = 'blue';
% p.FaceAlpha = 0.5;




