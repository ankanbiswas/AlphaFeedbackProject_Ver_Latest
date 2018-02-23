% This program is used to analysize the results of the alpha feedback project.
% Input - subjectName: A string to identify the subject.

function [colorNames,meanEyeOpenPowerList,meanEyeClosedPowerList,calibrationPowerList,trialTypeList1D,powerVsTimeList,timeVals,typeNameList] = avergaeDeltaPowerVsTimeAllSub(subjectName,folderName,~,~)

% if ~exist('subjectName','var');   subjectName='';                       end
% if ~exist('folderName','var');    folderName='';                        end
% if ~exist('displayResultsFlag','var');  displayResultsFlag=1;           end
% if ~exist('analysisPlotHandles','var'); analysisPlotHandles=[];         end

if isempty(folderName)
    pathStr = fileparts(pwd);
    folderName = fullfile(pathStr,'Data',subjectName);
end
% if isempty(analysisPlotHandles)
%     
%     % chnged this to have all the figured positioned accordingly in one
%     % figure itslef from the latewr one where it was one the lower half.
%     analysisPlotHandles.powerVsTrial = subplot(2,2,1);
%     analysisPlotHandles.diffPowerVsTrial = subplot(2,2,3);
%     analysisPlotHandles.powerVsTime = subplot(2,2,2);
%     analysisPlotHandles.barPlot = subplot(2,2,4);
%     
%     analysisPlotHandles.powerVsTrial = subplot('Position',[0.05 0.3 0.4 0.2]);
%     analysisPlotHandles.diffPowerVsTrial = subplot('Position',[0.05 0.05 0.4 0.2]);
%     analysisPlotHandles.powerVsTime = subplot('Position',[0.55 0.3 0.4 0.2]);
%     analysisPlotHandles.barPlot = subplot('Position',[0.55 0.05 0.4 0.2]);
    
% else
%     % Clear all plots
%     cla(analysisPlotHandles.powerVsTrial);
%     cla(analysisPlotHandles.diffPowerVsTrial);
%     cla(analysisPlotHandles.powerVsTime);
%     cla(analysisPlotHandles.barPlot);
% end

colorNames = 'rgb';
typeNameList{1}='Valid';
typeNameList{2}='Invalid';
typeNameList{3}='Constant';

% Get session and trial list in increasing order
[nextSessionNum,nextTrialNum,sessionNumListTMP,trialNumListTMP] = getExperimentProgress(subjectName,folderName);

if (nextSessionNum==1) && (nextTrialNum==1) % Experiment has not started yet
    % Do Nothing
else
    % Load saved data
    trialTypeFileName = fullfile(folderName,[subjectName 'trialTypeList.mat']);
    load(trialTypeFileName,'trialTypeList');

    sessionNumList = [];
    trialNumList   = [];
    for i=1:max(sessionNumListTMP)
        sessionPos     = find(sessionNumListTMP==i); % trails within current session 
        sessionNumList = cat(2,sessionNumList,sessionNumListTMP(sessionPos));
        trialNumList   = cat(2,trialNumList,sort(trialNumListTMP(sessionPos)));
    end
    
    numTotalTrials = length(sessionNumList);
    trialTypeList1D = zeros(1,numTotalTrials);
    for i=1:numTotalTrials
        trialTypeList1D(i) = trialTypeList(sessionNumList(i),trialNumList(i));
    end
    
    powerVsTimeList        = []; % Alpha Power as a function of time
    calibrationPowerList   = []; % Calibration power
    meanEyeOpenPowerList   = []; % Mean alpha power during Eye Open condition
    semEyeOpenPowerList    = []; % sem of alpha power during Eye Open condition
    meanEyeClosedPowerList = []; % Mean alpha power during Eye Closed condition
    semEyeClosedPowerList  = []; % sem of alpha power during Eye Closed condition
    
    for i=1:numTotalTrials
        calibrationData = load(fullfile(folderName,[subjectName 'CalibrationProcessedData' 'Session' num2str(sessionNumList(i)) '.mat']));
        analysisData    = load(fullfile(folderName,[subjectName 'ProcessedData' 'Session' num2str(sessionNumList(i)) 'Trial' num2str(trialNumList(i)) '.mat']));
        powerVsTimeTMP  = log10(mean(analysisData.tfData(analysisData.alphaPos,:),1));
        
        meanCalibrationPower = mean(log10(mean(calibrationData.tfData(calibrationData.alphaPos,calibrationData.timePosCalibration),1)));
        meanEyeOpenPower     = mean(powerVsTimeTMP(calibrationData.timePosCalibration));
        semEyeOpenPower      = std(powerVsTimeTMP(calibrationData.timePosCalibration))/sqrt(length(calibrationData.timePosCalibration));
        meanEyeClosedPower   = mean(powerVsTimeTMP(analysisData.timePosAnalysis));
        semEyeClosedPower    = std(powerVsTimeTMP(analysisData.timePosAnalysis))/sqrt(length(analysisData.timePosAnalysis));
        
        calibrationPowerList   = cat(2,calibrationPowerList,meanCalibrationPower);
        powerVsTimeList        = cat(1,powerVsTimeList,powerVsTimeTMP);
        meanEyeOpenPowerList   = cat(2,meanEyeOpenPowerList,meanEyeOpenPower);
        semEyeOpenPowerList    = cat(2,semEyeOpenPowerList,semEyeOpenPower);
        meanEyeClosedPowerList = cat(2,meanEyeClosedPowerList,meanEyeClosedPower);
        semEyeClosedPowerList  = cat(2,semEyeClosedPowerList,semEyeClosedPower);
    end
    
    timeVals = analysisData.timeValsTF;
    
%     if displayResultsFlag
%         % Plot Data
%         titleStr='';
%         
%         hold(analysisPlotHandles.powerVsTrial,'on');
%         
%         % Power versus Trial without any specific trial type indication:
%         
%         errorbar(analysisPlotHandles.powerVsTrial,meanEyeOpenPowerList,semEyeOpenPowerList,'color','k','marker','o');
%         errorbar(analysisPlotHandles.powerVsTrial,meanEyeClosedPowerList,semEyeClosedPowerList,'color','k','marker','V');
%         plot(analysisPlotHandles.powerVsTrial,calibrationPowerList,'color','k');
%         
%         hold(analysisPlotHandles.diffPowerVsTrial,'on');
%         hold(analysisPlotHandles.powerVsTime,'on');
%         hold(analysisPlotHandles.barPlot,'on');
%         for i=1:3 % Trial Type
%             trialPos = find(trialTypeList1D==i);
%             if i==3
%                 titleStr = cat(2,titleStr,[typeNameList{i} '=' num2str(length(trialPos))]);
%             else
%                 titleStr = cat(2,titleStr,[typeNameList{i} '=' num2str(length(trialPos)) ', ']);
%             end
%             
%             if ~isempty(trialPos)
%                 % Power versus Trial
%                 errorbar(analysisPlotHandles.powerVsTrial,trialPos,meanEyeOpenPowerList(trialPos),semEyeOpenPowerList(trialPos),'color',colorNames(i),'marker','o','linestyle','none');
%                 errorbar(analysisPlotHandles.powerVsTrial,trialPos,meanEyeClosedPowerList(trialPos),semEyeClosedPowerList(trialPos),'color',colorNames(i),'marker','V','linestyle','none');
%                 
%                 % Change in Power versus Trial, separated by trialType
%                 deltaPower = meanEyeClosedPowerList(trialPos)-calibrationPowerList(trialPos);
%                 errorbar(analysisPlotHandles.diffPowerVsTrial,deltaPower,semEyeClosedPowerList(trialPos),'color',colorNames(i),'marker','V');
%                 
%                 % Power versus time
%                 
%                 plot(analysisPlotHandles.powerVsTime,analysisData.timeValsTF,mean(powerVsTimeList(trialPos,:),1),'color',colorNames(i));
%                 
%                 % Bar Plot
%                 bar(analysisPlotHandles.barPlot,i,mean(deltaPower),colorNames(i));
%                 errorbar(analysisPlotHandles.barPlot,i,mean(deltaPower),std(deltaPower)/sqrt(length(deltaPower)),'color',colorNames(i));
%                 disp(mean(deltaPower));
%             end
%         end
%         title(analysisPlotHandles.powerVsTrial,titleStr);
%         xlim(analysisPlotHandles.barPlot,[0.5 3.5]);
%         set(analysisPlotHandles.barPlot,'XTick',1:3,'XTickLabel',typeNameList);
%         drawnow;
%     end
end