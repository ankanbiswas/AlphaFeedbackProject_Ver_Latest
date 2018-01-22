subjectNames{1}='ABa';
subjectNames{2}='AJ';
subjectNames{3}='DB';
subjectNames{4}='DD';
subjectNames{5}='HS';
subjectNames{6}='SB';
subjectNames{7}='SG';
subjectNames{8}='SS';
subjectNames{9}='SSH';


numSubjects=length(subjectNames);
startTrialPos=1;

for i=1:numSubjects
    disp(i);
    [analysisPlotHandles,colorNames,meanEyeOpenPowerList(i,:),meanEyeClosedPowerList(i,:),calibrationPowerList(i,:),trialTypeList1D(i,:),powerVsTimeList(i,:,:),timeVals,typeNameList] = biofeedbackAnalysis(subjectNames{i},'',0,[]);
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
        deltaPower(i,:) = meanEyeClosedPowerList(i,trialPos)-calibrationPowerList(i,trialPos);
        meanPowerVsTime(i,:) = squeeze(mean(powerVsTimeList(i,trialPos,:),2));
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

set(analysisPlotHandles.barPlot,'XTick',1:3,'XTickLabel',typeNameList);

[h,p]=ttest2(allDeltaPowerPerSubject{1},allDeltaPowerPerSubject{2});