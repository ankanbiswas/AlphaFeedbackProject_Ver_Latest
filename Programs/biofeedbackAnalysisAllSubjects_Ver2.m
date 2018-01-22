
% Creating cell containing list of all the subjects 
% Analysing total of 24 subjects out of 25 subjects 
% One subject didn't show any alpha activity

subjectNames = {'ABA','AJ','DB','DD','HS','SB','SG','SS','SSH','SKS','KNB','SSA','SHG','MP','MJR','ARC','TBR','BPP','SL','PK','PB','PM','SKH','AD'};
numSubjects=length(subjectNames);
startTrialPos = input('Input the start trial position, Default value 13 \n'); % change accordingly
if isempty(startTrialPos) % Check startTrialPos User Input
    startTrialPos = 13;
end

for i=1:numSubjects
    disp(i);
    [analysisPlotHandles,colorNames,meanEyeOpenPowerList(i,:),meanEyeClosedPowerList(i,:),calibrationPowerList(i,:),trialTypeList1D(i,:),powerVsTimeList(i,:,:),timeVals,typeNameList] = biofeedbackAnalysis_Ver2(subjectNames{i},'',0,[]);
end

meanAllEyeOpenPowerList = mean(meanEyeOpenPowerList,1);
semAllEyeOpenPowerList = std(meanEyeOpenPowerList,[],1)/sqrt(numSubjects);

meanAllEyeClosedPowerList = mean(meanEyeClosedPowerList,1);
semAllEyeClosedPowerList = std(meanEyeClosedPowerList,[],1)/sqrt(numSubjects);

allCalibrationPowerList = mean(calibrationPowerList,1);

hold(analysisPlotHandles.powerVsTrial,'on');
errorbar(analysisPlotHandles.powerVsTrial,meanAllEyeOpenPowerList,semAllEyeOpenPowerList,'color','k','marker','o');
errorbar(analysisPlotHandles.powerVsTrial,meanAllEyeClosedPowerList,semAllEyeClosedPowerList,'color','k','marker','V');
plot(analysisPlotHandles.powerVsTrial,allCalibrationPowerList,'color','k');

hold(analysisPlotHandles.diffPowerVsTrial,'on');
hold(analysisPlotHandles.powerVsTime,'on');
hold(analysisPlotHandles.barPlot,'on');
clear meanDeltaPower semDeltaPower

for j=1:3
    % delta power
    clear deltaPower meanPowerVsTime
    for i=1:numSubjects
        shortPosList = startTrialPos:60;
        trialPos = shortPosList(trialTypeList1D(i,shortPosList)==j);
        deltaPower(i,:) = 10*(meanEyeClosedPowerList(i,trialPos)-calibrationPowerList(i,trialPos));
        meanPowerVsTime(i,:) = 10*(squeeze(mean(powerVsTimeList(i,trialPos,:),2))-mean(calibrationPowerList(i,:)));
    end
    meanDeltaPower{j} = mean(deltaPower,1);
    semDeltaPower{j} = std(deltaPower,[],1)/sqrt(numSubjects);
    errorbar(analysisPlotHandles.diffPowerVsTrial,meanDeltaPower{j},semDeltaPower{j},'color',colorNames(j),'marker','V');
       
    % Bar Plot
    allDeltaPowerPerSubject{j} = deltaPower(:);
    bar(analysisPlotHandles.barPlot,j,mean(allDeltaPowerPerSubject{j}),colorNames(j));
    errorbar(analysisPlotHandles.barPlot,j,mean(allDeltaPowerPerSubject{j}),std(allDeltaPowerPerSubject{j})/sqrt(length(allDeltaPowerPerSubject{j})),'color',colorNames(j));
    
    % Power versus time
    axes(analysisPlotHandles.powerVsTime);
    meanAllPowerVsTime{j} = mean(meanPowerVsTime,1);
    semAllPowerVsTime{j}  = std(meanPowerVsTime,[],1)/sqrt(numSubjects);
%     plot(analysisPlotHandles.powerVsTime,meanAllPowerVsTime{j},'color',colorNames(j));
    shadedErrorBar(timeVals,meanAllPowerVsTime{j},semAllPowerVsTime{j},colorNames(j),1);
%     errorbar(analysisPlotHandles.powerVsTime,1:50,meanAllPowerVsTime{j},semAllPowerVsTime{j},'color',colorNames(j));

end

% legend([h1 h2 h3],'','','','Location','Best')
set(analysisPlotHandles.barPlot,'XTick',1:3,'XTickLabel',typeNameList);
xlabel(analysisPlotHandles.powerVsTrial,'TrialNo');
ylabel(analysisPlotHandles.powerVsTrial,'Raw Alpha Power(\muV^2)');
xlabel(analysisPlotHandles.diffPowerVsTrial,'TrialNo');
ylabel(analysisPlotHandles.diffPowerVsTrial,'\DeltaPower(dB)');
xlabel(analysisPlotHandles.powerVsTime,'Time(sec)');
ylabel(analysisPlotHandles.powerVsTime,'\DeltaPower(dB)');
xlabel(analysisPlotHandles.barPlot,'TrialTypes');
ylabel(analysisPlotHandles.barPlot,'\DeltaPower(dB)');    

% perform ttest and display result to the user
[h,p,ci]=ttest2(allDeltaPowerPerSubject{1},allDeltaPowerPerSubject{2},'Vartype','equal'); % clarify
[h2,p2,ci2]=ttest2(allDeltaPowerPerSubject{1},allDeltaPowerPerSubject{3},'Vartype','unequal');
if h == 1   ,disp('Significant difference between the means of Valid and invalid trials');
else        disp('No significant difference between the means of Valid and invalid trials');
end

if(h2 == 1) ,disp('Significant difference between the means of Invalid and constant trials');
else         disp('No Significant difference between the means of Valid and Constant trials');
end  