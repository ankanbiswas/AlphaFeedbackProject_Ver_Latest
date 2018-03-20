
% Prepare data
y=randn(30,80)*5;
x=(1:size(y,2))-40;
yP = sin( linspace(-2*pi,2*pi,length(x)) )*20;
y = bsxfun(@plus,y,yP)+60;

% Make the plot
clf
shadedErrorBar(x,y,{@mean,@std}); 

% Overlay the raw data
hold on
plot(x,y,'.','color',[0.5,0.5,0.95])

grid on

% Prepare data for first line
y=ones(30,1)*x; 
y=y+0.06*y.^2+randn(size(y))*10;

clf
shadedErrorBar(x,y,{@mean,@std},'lineprops','-b','patchSaturation',0.33)

% Overlay second line
hold on
shadedErrorBar(x,2*y+20,{@mean,@std},'lineprops',{'-go','MarkerFaceColor','g'});

%Overlay third line
y=randn(30,80)*5; 
x=(1:size(y,2))-40;
yP = sin( linspace(-2*pi,2*pi,length(x)) )*20;
y = bsxfun(@plus,y,yP)+60;

% Make this line non-transparent
shadedErrorBar(x, y, {@mean,@std}, 'lineprops', '-r','transparent',false,'patchSaturation',0.075)

grid on