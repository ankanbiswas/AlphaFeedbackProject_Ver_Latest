
%% MATLAB Plot Gallery - Plot in Plot

% Create data
t = linspace(0,2*pi);
t(1) = eps;
y = sin(t);

% Place axes at (0.1,0.1) with width and height of 0.8
figure(1);
handaxes1 = axes('Position', [0.12 0.12 0.8 0.8]);

% Main plot
plot(t, y)
xlabel('t')
ylabel('sin(t)')
set(handaxes1, 'Box', 'off');

% Adjust XY label font
handxlabel1 = get(gca, 'XLabel');
set(handxlabel1, 'FontSize', 16, 'FontWeight', 'bold')
handylabel1 = get(gca, 'ylabel');
set(handylabel1, 'FontSize', 16, 'FontWeight', 'bold')

% Place second set of axes on same plot
handaxes2 = axes('Position', [0.6 0.6 0.2 0.2]);
fill(t, y.^2, 'g')
set(handaxes2, 'Box', 'off')
xlabel('t')
ylabel('(sin(t))^2')

% Adjust XY label font
set(get(handaxes2, 'XLabel'), 'FontName', 'Times')
set(get(handaxes2, 'YLabel'), 'FontName', 'Times')

% Add another set of axes
handaxes3 = axes('Position', [0.25 0.25 0.2 0.2]);
plot(t, y.^3)
set(handaxes3, 'Box','off')
xlabel('t')
ylabel('(sin(t))^3')


%% patch: tested and worked on february @18. Code exerpts from Aritra:
%%%%%%%%%%%%%%%%%%%%% Test whether different from zero %%%%%%%%%%%%%%%%%%%%
% %% test code for patch
% 
% hPlot  = figure(1);
% yLims = [0 5];
% dX=1; dY = diff(yLims)/20; % define dX and dY according to your data
% 
% contrastIndices = rand(10,2,1)';
% numContrasts = size(contrastIndices,1);
% 
% 
% % if numDays>1
%     for i=1:numContrasts
% %         [~,p] = ttest(miData(:,i)); % Here goes your data which is fed to ttest function
%         [~,p] = ttest(contrastIndices);
%         
%         if p<0.05/numContrasts
%             pColor = 'r';
%         elseif p<0.05
%             pColor = 'g';
%         else
%             pColor = 'w';
%         end
%         
%         patchX = contrastIndices(i)-dX/2;
%         patchY = yLims(1);
%         patchLocX = [patchX patchX patchX+dX patchX+dX];
%         patchLocY = [patchY patchY+dY patchY+dY patchY];
% %         patch(patchLocX,patchLocY,pColor,'Parent',hPlot,'EdgeColor',pColor);
%         patch(patchLocX,patchLocY,pColor,'EdgeColor',pColor);
%              
%     end
% % end

