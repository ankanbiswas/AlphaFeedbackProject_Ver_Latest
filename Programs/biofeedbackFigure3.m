% biofeedbackFigure3(subjectName,folderName)
% Main aim of the code is to plot deltapower with time for all the
% subject
% In immediete future aim is to develop it further to include the slope

% total no of trials = 60 (5*12)
% Duration of trial  = 50 sec

% trialtypes: Valid: 1, Invalid: 2, Constant: 3;

fontsize = 10;

subjectNames = {'ABA','AJ','DB','DD','HS','SB','SG','SS','SSH','SKS', ...
    'KNB','SSA','SHG','MP','MJR','ARC','TBR','BPP','SL', ...
    'PK','PB','PM','SKH','AD'}';
numSubjects = 24; % no of subjects for which analysis would be carried out

% Change the subplots in the figure accroding to the numsubjects
% And get the passon the figurehandles when the analysis function is called

if numSubjects <= 6
    h = getPlotHandles(1,numSubjects);
else
    h = getPlotHandles(ceil(numSubjects/6),6);
end

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

for i=1:numSubjects
    subInd = i;
    disp(subInd);
    plotH.deltaPowerVsTime = h3(i);
    %     h= figure(i);
    %     set(h, 'Visible', 'on'); % Control visibility of the figure
    
    [plotH,colorNames,~,~,~,~,~,~,~,~,~,timeVals,typeNameList] ...
        = ba_EX_meanDeltaPowerVsTime(subjectNames{subInd},'',1,plotH);
    %     flag;
    
    %%%% Changing plot properties
    % legend([h1 h2 h3],'','','','Location','Best')
    title(plotH.deltaPowerVsTime,['Subject',num2str(i)]);
    if numSubjects <= 6 || subInd >= 19
        xlabel(plotH.deltaPowerVsTime,'Time(sec)','fontsize',fontsize,'fontweight','bold');
    end
    if  subInd == 1 || subInd == 7 || subInd == 13 || subInd == 19
        ylabel(plotH.deltaPowerVsTime,'\DeltaPower(dB)','fontsize',fontsize,'fontweight','bold');
    end
%     set(plotH.deltaPowerVsTim,'fontsize',fontsize,'fontweight','bold');
    
    %     disp('one subject data analysis completed');
end

% save('EX_mean_deltaPowerVsTimeList_trialtypes','EX_mean_deltaPowerVsTimeList_valid','EX_mean_deltaPowerVsTimeList_invalid','EX_mean_deltaPowerVsTimeList_constant');

% end