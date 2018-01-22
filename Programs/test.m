

numSubjects = 10; % no of subjects for which analysis would be carried out

% Change the subplots in the figure accroding to the numsubjects
% And get the passon the figurehandles when the analysis function is called

if numSubjects <= 6
    h = getPlotHandles(1,numSubjects);
else    
    h = getPlotHandles(ceil(numSubjects/6),6);
end


