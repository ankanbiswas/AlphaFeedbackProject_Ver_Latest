

x = [0:10:100; (0:10:100)+2];
X = reshape(repelem(x(:),2),4,[]);
Y = repmat([0; 10; 10; 0],1,size(X,2));
p = patch(X,Y,'r','EdgeColor','k', 'FaceAlpha', 0.2);