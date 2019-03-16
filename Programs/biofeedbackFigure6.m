% Good morning: 9:42am on 15th March, 2019; Ankan Biswas. 
% Steps of code now:

% For doing the analysis for an individual subject:

% 1. Get the trial sequence for that subject. 

% 2. Make a new trial sequence, using the above trial sequence, 
    % by assigning 0 to the invalid/constant trials, and
    % by assigning 1 to the valid trials.

% 3. Now using the above trial sequence separate out the respective trials
% using %- separateTrailPos -% function. 

% 4. Now for that respective trials, one by one, pull out the change in alpha
% power from the baseline, followed by avergaing across the trials, 
% and plot them in a unique color with respect to the time. 

%----- Advice/Note: Use figre 1.E for an reference,
% or use %- biofeedbackFigure_2 -% as an

% easy reference. -------%


%% Begin your code here: 

% biofeedbackFigure3(subjectName,folderName)
% Main aim of the code is to plot deltapower with time for all the
% subject
% In immediete future aim is to develop it further to include the slope

% total no of trials = 60 (5*12)
% Duration of trial  = 50 sec

% trialtypes: Valid: 1, Invalid: 2, Constant: 3;
% figure(102);

hfigure_2 = figure(102);
haxfigure_2 = axes('parent',hfigure_2);
% hfigure_2.PaperType = 'a4';
% hfigure_2.PaperUnits = 'centimeters';
% hfigure_2.PaperSize = [18.3 24.7/2];
% hfigure_2.PaperOrientation = 'Portrait';
% hfigure_2.PaperPosition = [0 0 hfigure_2.PaperSize];
hfigure_2.Color = [1 1 1];
fontsize = 12;
startTrialTimePos = 13; % default one

% subjectNames = {'ABA','AJ','DB','DD','HS',...
%                 'SB','SG','SS','SSH','SKS', ...
%                 'KNB','SSA','SHG','MP','MJR',...
%                 'ARC','TBR','BPP','SL','PK',...
%                 'PB','PM','SKH','AD'}';
subjectNames = {'ABA','ARC','DD','AJ','SG',...
                'MP','PB','SSA','SL','DB', ...
                'PK','HS','AD','SB','SKS','SS',...
                'SHG','KNB','BPP','SSH',...
                'MJR','TBR','SKH','PM'}';

numSubjects = length(subjectNames); % no of subjects for which analysis would be carried out
numSubList = 1:numSubjects;
numSubList = numSubList';
% Change the subplots in the figure accroding to the numsubjects
% And get the passon the figurehandles when the analysis function is called

% if numSubjects <= 6
%     h = getPlotHandles(1,numSubjects);
% else
%     h = getPlotHandles(ceil(numSubjects/6),6);
% end

h = getPlotHandles(4,6,[0.06 0.1 0.9 0.83],0.02,0.02);
h2 = h';
h3 = h2(:);

% Initilizing variables for storing the reuired data:
% meanEyeOpenPowerList    = [];
% meanEyeClosedPowerList  = [];
% calibrationPowerList    = [];
% trialTypeList1D         = [];
% powerVsTimeList         = [];
% deltaPowerVsTimeList    = [];
% EX_mean_deltaPowerVsTimeList_valid      = [];
% EX_mean_deltaPowerVsTimeList_invalid    = [];
% EX_mean_deltaPowerVsTimeList_constant   = [];
AllSubPVal = [];

for i=1:numSubjects
    subInd = i;
    disp(subInd);
    plotH.deltaPowerVsTime = h3(i);
    %     h= figure(i);
    %     set(h, 'Visible', 'on'); % Control visibility of the figure
    
%     [plotH,colorNames,~,~,~,~,~,~,~,~,~,timeVals,typeNameList,SubPValTemp] ...
%         = ba_EX_meanDeltaPowerVsTime(subjectNames{subInd},'',1,plotH,startTrialTimePos,subInd);
    
    [plotH,colorNames,~,~,~,~,~,~,~,~,~,timeVals,typeNameList,SubPValTemp] ...
        = ba_EX_meanDeltaPowerVsTime_figmod_v2(subjectNames{subInd},'',1,plotH,startTrialTimePos,subInd);
    
%     [PlotH,colorNames,meanEyeOpenPowerList,...
%             meanEyeClosedPowerList,calibrationPowerList, ...
%             trialTypeList1D,powerVsTimeList,deltaPowerVsTimeList,EX_mean_deltaPowerVsTimeList_valid,...
%             EX_mean_deltaPowerVsTimeList_invalid,EX_mean_deltaPowerVsTimeList_constant,...
%             timeVals,typeNameList,SubPValTemp]   =   ba_EX_meanDeltaPowerVsTime_figmod_v2(subjectNames{subInd},'',1,plotH,startTrialTimePos,subInd);
    
    %     flag;
    
    %% ------------------------- Just making decorations here.
    %---------------------
    
    %%%% Changing plot properties
    % legend([h1 h2 h3],'','','','Location','Best')
    %     title(plotH.deltaPowerVsTime,['Subject',num2str(i)]);
    % making all the axis equal:
    %     ylim(plotH.deltaPowerVsTime,[-0.5 1.8]);
    xlim(plotH.deltaPowerVsTime,[5 52]);
    
    if subInd == 19
        xlabel(plotH.deltaPowerVsTime,'Time (s)','fontsize',30,'fontweight','bold');
    end
    if  subInd == 19
        ylabel(plotH.deltaPowerVsTime,'\Delta Alpha power (dB)','fontsize',30,'fontweight','bold');
    else
        set(plotH.deltaPowerVsTime,'yticklabel',[]);
    end
    %     set(plotH.deltaPowerVsTim,'fontsize',fontsize,'fontweight','bold');
    %     disp('one subject data analysis completed');
    AllSubPVal = [AllSubPVal;SubPValTemp];
end

set(findobj(gcf,'type','axes'),'box','off'...
    ,'fontsize',14 ...
    ,'FontWeight','Bold'...
    ,'TickDir','out'...
    ,'TickLength',[0.02 0.02]...
    ,'linewidth',1.5 ...
    ,'xcolor',[0 0 0]...
    ,'ycolor',[0 0 0]...
    );

set(findall(gcf, 'Type', 'Line'),'LineWidth',2)

SublistPvalueMat = [AllSubPVal,numSubList];
[~,idx] = sort(SublistPvalueMat(:,1));
SublistPvalueMatSorted = SublistPvalueMat(idx,:);
% SublistPValueCell{:,1} = subjectNames;
% SublistPValueCell{:,2} = AllSubPVal;

save('EX_AllSubPVal','SublistPvalueMat','SublistPvalueMatSorted');
% end






   