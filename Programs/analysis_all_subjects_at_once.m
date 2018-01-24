
subjectNames = {'ABA','AJ','DB','DD','HS','SB','SG','SS','SSH','SKS', ...
    'KNB','SSA','SHG','MP','MJR','ARC','TBR','BPP','SL','PK','PB','PM','SKH','AD'}';

% numSubjects=length(subjectNames); 
numSubjects = 2;

for i=1:numSubjects
    disp(i);
    figure(i);    
    [analysisPlotHandles,colorNames,meanEyeOpenPowerList(i,:), ...
    meanEyeClosedPowerList(i,:),calibrationPowerList(i,:), ...
    trialTypeList1D(i,:),powerVsTimeList(i,:,:),timeVals,typeNameList] ...
        = biofeedbackAnalysis_Ver2(subjectNames{i},'',1,[]);
    % legend([h1 h2 h3],'','','','Location','Best')
    set(analysisPlotHandles.barPlot,'XTick',1:3,'XTickLabel',typeNameList);
    xlabel(analysisPlotHandles.powerVsTrial,'TrialNo');
    ylabel(analysisPlotHandles.powerVsTrial,'Raw Alpha Power(\muV^2)');
    xlabel(analysisPlotHandles.diffPowerVsTrial,'TrialNo');
    ylabel(analysisPlotHandles.diffPowerVsTrial,'\DeltaPower(dB)');
%     title(['Subject',num2str(i)]);
    % legend([h1 h2 h3],'','','','Location','Best')
    title(analysisPlotHandles.powerVsTime,['Subject',num2str(i)]);
    xlabel(analysisPlotHandles.powerVsTime,'Time(sec)');
    ylabel(analysisPlotHandles.powerVsTime,'\DeltaPower(dB)');
    xlabel(analysisPlotHandles.barPlot,'TrialTypes');
    ylabel(analysisPlotHandles.barPlot,'\DeltaPower(dB)');    
    disp('one subject data analysis completed');
end