function patchSelfTry(subjectName,folderName)
    
    hFigure1            = figure(1);
    hExperimentHandle   = subplot('Position',[0.05 0.85 0.9 0.04],'Parent',hFigure1);
    dX = 1; dY = 1;
    colorNameTypes = 'rgb';
    
    % Take input the subject name as strings and load the triallist file name
    % from the specific folder:
    
    if isempty(folderName)
        pathStr     = fileparts(pwd);
        folderName  = fullfile(pathStr,'Data',subjectName);
    end
    
    % Load saved data
    trialTypeFileName = fullfile(folderName,[subjectName 'trialTypeList.mat']);
    load(trialTypeFileName,'trialTypeList');
    
    % input: trialtype list:
    trialTypeList1D = trialTypeList';
    trialTypeList1D = trialTypeList1D(:);
    
    % plotting the experimental plot using patch
    hold(hExperimentHandle,'on');    
        
    for i = 1:3
        pos         = find(trialTypeList1D == i);
        patchX      = pos'; 
        patchLocX   = [patchX; patchX; patchX+dX; patchX+dX];
        patchY      = zeros(size(patchX));
        patchLocY   = [patchY; patchY+dY; patchY+dY; patchY];
        patch(patchLocX,patchLocY,colorNameTypes(i),'parent',hExperimentHandle,'EdgeColor','k');
        xlim([0, 61]); ylim([-2, 2]); xlabel('Trial No');
%         plot(hExperimentHandle,pos,0,'marker','o','color',colorNameTypes(i));
    end
end