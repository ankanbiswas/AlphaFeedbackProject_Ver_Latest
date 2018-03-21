
function averageDeltaPowerVsTime(startTrialTimePos,hAverageDeltaPowerVsTime,fontsize)
%     subjectNames = {'ABA','AJ','DB','DD','HS','SB','SG','SS','SSH','SKS','KNB','SSA','SHG','MP','MJR','ARC','TBR','BPP','SL','PK','PB','PM','SKH','AD'};
    subjectNames = {'PB'};
    numSubjects=length(subjectNames);
%     startTrialTimePos = input('Input the start trial position, Default value 13 \n'); % change accordingly
    if ~exist('startTrialTimePos','var'),  startTrialTimePos = 13; end %taking default value
    
    for i=1:numSubjects
    disp(i);
    [colorNames,meanEyeOpenPowerList(i,:),meanEyeClosedPowerList(i,:),calibrationPowerList(i,:),trialTypeList1D(i,:),powerVsTimeList(i,:,:),timeVals,typeNameList] = avergaeDeltaPowerVsTimeAllSub(subjectNames{i},'',0,[]);
    end
    hAverageDeltaPowerVsTime = hAverageDeltaPowerVsTime;
    hold(hAverageDeltaPowerVsTime,'on');
    for j=1:3
        % delta power
        clear deltaPower meanPowerVsTime
        for i=1:numSubjects
            shortPosList = startTrialTimePos:60;
            trialPos = shortPosList(trialTypeList1D(i,shortPosList)==j);
            deltaPower(i,:) = 10*(meanEyeClosedPowerList(i,trialPos)-calibrationPowerList(i,trialPos));
            meanPowerVsTime(i,:) = 10*(squeeze(mean(powerVsTimeList(i,trialPos,:),2))-mean(calibrationPowerList(i,:)));
        end
        % Power versus time
        
        axes(hAverageDeltaPowerVsTime);
        meanAllPowerVsTime{j} = mean(meanPowerVsTime,1);
        semAllPowerVsTime{j}  = std(meanPowerVsTime,[],1)/sqrt(numSubjects);
        plot(timeVals,meanAllPowerVsTime{j},'color',colorNames(j),'linewidth',3);
%         shadedErrorBar(timeVals,meanAllPowerVsTime{j},semAllPowerVsTime{j},colorNames(j),1);
    end
    xlim(hAverageDeltaPowerVsTime,[5 50]);
    xlabel(hAverageDeltaPowerVsTime,'Time(sec)','fontsize',fontsize,'fontweight','bold');
    ylabel(hAverageDeltaPowerVsTime,'\DeltaPower(dB)','fontsize',fontsize,'fontweight','bold');
    hold(hAverageDeltaPowerVsTime,'off');
end
