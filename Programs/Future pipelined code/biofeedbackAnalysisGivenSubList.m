
% Combined analysis of the given subject list

% sublist = {'SB','SS','HS','ABa','DD','DB','AJ','SG','SSH'}; % Given subject list for analysis

sublist{1}='ABA';
% sublist{1}='AJ';
% sublist{1}='DB';
% sublist{4}='DD';
% sublist{5}='HS';
% sublist{6}='SB';
% sublist{7}='SG';
% sublist{8}='SS';
% sublist{9}='SSH';
% sublist{10}='SKS';
% sublist{11}='KNB';
% sublist{12}='SSa';
% sublist{13}='SHK';
% sublist{14}='MP';
% sublist{15}='MJR';
% sublist{16}='ARC';
% sublist{17}='BBR';
% sublist{18}='BPP';
% sublist{19}='SL';
% sublist{20}='PK';
% sublist{21}='PB';
% sublist{22}='PMF';
% sublist{23}='SKH';
% sublist{24}='AD';

analysisPlotHandles.powerVsTrial        = subplot('Position',[0.05 0.3 0.4 0.2]);
analysisPlotHandles.diffPowerVsTrial    = subplot('Position',[0.05 0.05 0.4 0.2]);
analysisPlotHandles.powerVsTime         = subplot('Position',[0.55 0.3 0.4 0.2]);
analysisPlotHandles.barPlot             = subplot('Position',[0.55 0.05 0.4 0.2]);

colorNames      = 'rgb';
typeNameList{1} = 'Valid';
typeNameList{2} = 'Invalid';
typeNameList{3} = 'Constant';

% Initializing all the variables for combining the subjects data
ALLSubPowerVsTimeList          = [];   % Alpha Power as a function of time
ALLSubCalibrationPowerList     = [];   % Calibration power
ALLSubEyeOpenPowerList     = [];   % Mean alpha power during Eye Open condition
ALLSubSemEyeOpenPowerList      = [];   % sem of alpha power during Eye Open condition
ALLSubEyeClosedPowerList       = [];   % Mean alpha power during Eye Closed condition
ALLSubSemEyeClosedPowerList    = [];   % sem of alpha power during Eye Closed condition
ALLSubTrialTypeList1D          = [];   % All the trialtypelist combined
AllSubDeltaPowerList           = [];
% Initializing variables separated by trialtypes
ALLSubValidTrialDeltaPower          = [];
AllSubValidTrialDeltaPowerVsTime    = [];
ALLSubInvalidTrialDeltaPower        = [];
AllSubInvalidTrialDeltaPowerVsTime  = [];
AllSubConstantTrialDeltaPower       = [];
AllSubConstantTrialDeltaPowerVsTime = [];



for i = 1:length(sublist)
    
    subjectName = sublist{1,i};
    pathStr = fileparts(pwd);
    folderName = fullfile(pathStr,'Data',subjectName);
    
    % Get session and trial list in increasing order
    [nextSessionNum,nextTrialNum,sessionNumListTMP,trialNumListTMP] = getExperimentProgress(subjectName,folderName);
    
    % Load saved data
    trialTypeFileName = fullfile(folderName,[subjectName 'trialTypeList.mat']); % loading trialtype list file
    load(trialTypeFileName,'trialTypeList');

    sessionNumList=[];
    trialNumList=[];
    
    for i=1:max(sessionNumListTMP)  % getting all the trials (60) session numbers and the completed trialnumber list
        sessionPos = find(sessionNumListTMP==i);
        sessionNumList = cat(2,sessionNumList,sessionNumListTMP(sessionPos));
        trialNumList = cat(2,trialNumList,sort(trialNumListTMP(sessionPos)));
    end
    
    numTotalTrials = length(sessionNumList); % getting total number of trials
    trialTypeList1D=zeros(1,numTotalTrials);
    for i=1:numTotalTrials
        trialTypeList1D(i) = trialTypeList(sessionNumList(i),trialNumList(i)); % getting trialnumbers in 1 d list
    end

    ALLSubTrialTypeList1D = cat(1,ALLSubTrialTypeList1D,trialTypeList1D);

    DeltaPowerVsTimeList    = []; % Alpha Power as a function of time
    calibrationPowerList    = []; % Calibration power
    meanEyeOpenPowerList    = []; % Mean alpha power during Eye Open condition
    meanEyeClosedPowerList  = []; % Mean alpha power during Eye Closed condition      

    for i=1:numTotalTrials
        calibrationData = load(fullfile(folderName,[subjectName 'CalibrationProcessedData' 'Session' num2str(sessionNumList(i)) '.mat']));
        analysisData = load(fullfile(folderName,[subjectName 'ProcessedData' 'Session' num2str(sessionNumList(i)) 'Trial' num2str(trialNumList(i)) '.mat']));
        rawPowerVsTimeTMP = log10(mean(analysisData.tfData(analysisData.alphaPos,:),1));
                      
        meanCalibrationPower = mean(log10(mean(calibrationData.tfData(calibrationData.alphaPos,calibrationData.timePosCalibration),1)));
        
        DeltaPowerVsTimeTMP = rawPowerVsTimeTMP - repmat(meanCalibrationPower,1,length(rawPowerVsTimeTMP));
        
        meanEyeOpenPower = mean(DeltaPowerVsTimeTMP(calibrationData.timePosCalibration));
        meanEyeClosedPower = mean(DeltaPowerVsTimeTMP(analysisData.timePosAnalysis));
        
        DeltaPowerVsTimeList = cat(1,DeltaPowerVsTimeList,DeltaPowerVsTimeTMP);
        calibrationPowerList = cat(2,calibrationPowerList,meanCalibrationPower);
        meanEyeOpenPowerList = cat(2,meanEyeOpenPowerList,meanEyeOpenPower);
        meanEyeClosedPowerList = cat(2,meanEyeClosedPowerList,meanEyeClosedPower);

    end
    
        ALLTrialPowerVsTimeList        = mean(DeltaPowerVsTimeList);
        ALLTrialDeltaPowerList         = meanEyeClosedPowerList - calibrationPowerList;
        
        ALLSubCalibrationPowerList     = cat(1,ALLSubCalibrationPowerList,calibrationPowerList);
        ALLSubEyeOpenPowerList     = cat(1,ALLSubEyeOpenPowerList,meanEyeOpenPowerList);
        ALLSubEyeClosedPowerList       = cat(1,ALLSubEyeClosedPowerList ,meanEyeClosedPowerList);
        ALLSubPowerVsTimeList          = cat(1,ALLSubPowerVsTimeList,ALLTrialPowerVsTimeList);
        AllSubDeltaPowerList           = cat(1,AllSubDeltaPowerList,ALLTrialDeltaPowerList);
        
        % All the data separated by trialtypes
        
        for i=1:3 % Trial Type
             trialPos = find(trialTypeList1D==i);
             
             % Power versus Trial
             % 1st is Valid trial; 2nd is Invalid; 3rd is Constant trial.
             
            switch i                
               case 1
                     ValidTrialDeltaPower         = ALLTrialDeltaPowerList(trialPos);  % Change in Power versus Trial, separated by trialType
                     ValidTrialDeltaInPowerVsTime = mean(DeltaPowerVsTimeList(trialPos,:),1);
                case 2
                    InvalidTrialDeltaPower        = ALLTrialDeltaPowerList(trialPos);
                    InvalidTrialDeltaPowerVsTime  = mean(DeltaPowerVsTimeList(trialPos,:),1);
                case 3
                    ConstantTrialDeltaPower       = ALLTrialDeltaPowerList(trialPos);
                    ConstantTrialDeltaPowerVsTime = mean(DeltaPowerVsTimeList(trialPos,:),1);
            end              
        end
        
        ALLSubValidTrialDeltaPower          = cat(1,ALLSubValidTrialDeltaPower,ValidTrialDeltaPower);
        AllSubValidTrialDeltaPowerVsTime    = cat(1,AllSubValidTrialDeltaPowerVsTime,ValidTrialDeltaInPowerVsTime);
        
        ALLSubInvalidTrialDeltaPower        = cat(1,ALLSubInvalidTrialDeltaPower,InvalidTrialDeltaPower);
        AllSubInvalidTrialDeltaPowerVsTime  = cat(1,AllSubInvalidTrialDeltaPowerVsTime,InvalidTrialDeltaPowerVsTime);
        
        AllSubConstantTrialDeltaPower       = cat(1,AllSubConstantTrialDeltaPower,ConstantTrialDeltaPower);
        AllSubConstantTrialDeltaPowerVsTime = cat(1,AllSubConstantTrialDeltaPowerVsTime,ConstantTrialDeltaPowerVsTime);
end

% Plot Data
    titleStr='';
    
    hold(analysisPlotHandles.powerVsTrial,'on');
    errorbar(analysisPlotHandles.powerVsTrial,mean(ALLSubEyeOpenPowerList),std(ALLSubEyeOpenPowerList)/sqrt(length(sublist)),'color','b','marker','o');
    errorbar(analysisPlotHandles.powerVsTrial,mean(ALLSubEyeClosedPowerList),std(ALLSubEyeClosedPowerList)/sqrt(length(sublist)),'color','m','marker','V');
    plot(analysisPlotHandles.powerVsTrial,mean(ALLSubCalibrationPowerList),'color','k');
    
    hold(analysisPlotHandles.diffPowerVsTrial,'on');
    hold(analysisPlotHandles.powerVsTime,'on');
    hold(analysisPlotHandles.barPlot,'on');
    
    for i=1:3 % Trial Type
        
%         if i==3
%             titleStr = cat(2,titleStr,[typeNameList{i} '=' num2str(length(trialPos))]);
%         else
%             titleStr = cat(2,titleStr,[typeNameList{i} '=' num2str(length(trialPos)) ', ']);
%         end
       
        switch i             
            case 1
                % Change in power vs Trial, separated by trialtypes
                errorbar(analysisPlotHandles.diffPowerVsTrial,mean(ALLSubValidTrialDeltaPower),std(ALLSubValidTrialDeltaPower)/sqrt(length(sublist)),'color',colorNames(i),'marker','V');

                % Power versus time
                plot(analysisPlotHandles.powerVsTime,analysisData.timeValsTF,mean(AllSubValidTrialDeltaPowerVsTime),'color',colorNames(i));

                % Bar Plot
                bar(analysisPlotHandles.barPlot,i,mean(mean(ALLSubValidTrialDeltaPower)),colorNames(i));
                errorbar(analysisPlotHandles.barPlot,i,mean(mean(ALLSubValidTrialDeltaPower)),std(mean(ALLSubValidTrialDeltaPower))/sqrt(length(sublist)),'color',colorNames(i));
            
            case 2
                 % Change in power vs Trial, separated by trialtypes
                errorbar(analysisPlotHandles.diffPowerVsTrial,mean(ALLSubInvalidTrialDeltaPower),std(ALLSubInvalidTrialDeltaPower)/sqrt(length(sublist)),'color',colorNames(i),'marker','V');

                % Power versus time
                plot(analysisPlotHandles.powerVsTime,analysisData.timeValsTF,mean(AllSubInvalidTrialDeltaPowerVsTime),'color',colorNames(i));

                % Bar Plot
                bar(analysisPlotHandles.barPlot,i,mean(mean(ALLSubInvalidTrialDeltaPower)),colorNames(i));
                errorbar(analysisPlotHandles.barPlot,i,mean(mean(ALLSubInvalidTrialDeltaPower)),std(mean(ALLSubInvalidTrialDeltaPower))/sqrt(length(sublist)),'color',colorNames(i));
           
            case 3
                 % Change in power vs Trial, separated by trialtypes
                errorbar(analysisPlotHandles.diffPowerVsTrial,mean(AllSubConstantTrialDeltaPower),std(AllSubConstantTrialDeltaPower)/sqrt(length(sublist)),'color',colorNames(i),'marker','V');

                % Power versus time
                plot(analysisPlotHandles.powerVsTime,analysisData.timeValsTF,mean(AllSubConstantTrialDeltaPowerVsTime),'color',colorNames(i));

                % Bar Plot
                bar(analysisPlotHandles.barPlot,i,mean(mean(AllSubConstantTrialDeltaPower)),colorNames(i));
                errorbar(analysisPlotHandles.barPlot,i,mean(mean(AllSubConstantTrialDeltaPower)),std(mean(AllSubConstantTrialDeltaPower))/sqrt(length(sublist)),'color',colorNames(i));
         end
    end
%     
%     title(analysisPlotHandles.powerVsTrial,titleStr);
    xlim(analysisPlotHandles.barPlot,[0.5 3.5]);
    set(analysisPlotHandles.barPlot,'XTick',1:3,'XTickLabel',typeNameList);
    drawnow;






