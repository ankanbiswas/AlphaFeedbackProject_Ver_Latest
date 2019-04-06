% Modified from biofeedbackAnalysis_Ver2 on 21st jan,18 by @AB
% This program is used to extract out the delta power from the saved data.

% Input - subjectName: A string to identify the subject.

function [PlotH,colorNames,meanEyeOpenPowerList,...
            meanEyeClosedPowerList,calibrationPowerList, ...
            trialTypeList1D,powerVsTimeList,deltaPowerVsTimeList,EX_mean_deltaPowerVsTimeList_valid,...
            EX_mean_deltaPowerVsTimeList_invalid,EX_mean_deltaPowerVsTimeList_constant,...
            timeVals,typeNameList,SubPValTemp]...
            =   ba_EX_meanDeltaPowerVsTime_figmod_v2 ...
                    (subjectName,folderName,...
                    displayResultsFlag,PlotH,startTrialTimePos,subInd)
    
    
    if ~exist('subjectName','var');         subjectName='';                       end
    if ~exist('folderName','var');          folderName='';                        end
    if ~exist('displayResultsFlag','var');  displayResultsFlag=1;                 end
    if ~exist('PlotH','var');               PlotH=[];                             end
    if ~exist('fontSizeVal','var');         fontSizeVal = 12;                     end
    if ~exist('startTrialTimePos','var'),   startTrialTimePos = 13;               end %taking default value
    
    if isempty(folderName)
        pathStr = fileparts(pwd);
        folderName = fullfile(pathStr,'Data',subjectName);
    end
    if isempty(PlotH)
        %     analysisPlotHandles.powerVsTrial        = subplot(2,2,1);
        %     analysisPlotHandles.diffPowerVsTrial    = subplot(2,2,3);
        plotH_deltaPowerVsTime         = subplot(1,1,1);
        %     analysisPlotHandles.barPlot             = subplot(2,2,4);
        
        %     analysisPlotHandles.powerVsTrial = subplot('Position',[0.05 0.3 0.4 0.2]);
        %     analysisPlotHandles.diffPowerVsTrial = subplot('Position',[0.05 0.05 0.4 0.2]);
        %     analysisPlotHandles.powerVsTime = subplot('Position',[0.55 0.3 0.4 0.2]);
        %     analysisPlotHandles.barPlot = subplot('Position',[0.55 0.05 0.4 0.2]);
        
    else
        % Clear all plots
        %     cla(analysisPlotHandles.powerVsTrial);
        %     cla(analysisPlotHandles.diffPowerVsTrial);
        %     cla(analysisPlotHandles.powerVsTime);
        %     cla(analysisPlotHandles.barPlot);
        % Unpack the handle to get the plot handle
        plotH_deltaPowerVsTime = PlotH.deltaPowerVsTime;
    end
    
    colorNames      = 'rgb';
    typeNameList{1} ='Valid';
    typeNameList{2} ='Invalid';
    typeNameList{3} ='Constant';
    
    % Get session and trial list in increasing order
    [nextSessionNum,nextTrialNum,sessionNumListTMP,trialNumListTMP] ...
        = getExperimentProgress(subjectName,folderName);
    
    if (nextSessionNum==1) && (nextTrialNum==1) % Experiment has not started yet
        % Do Nothing
    else
        % Load saved data
        trialTypeFileName = fullfile(folderName,[subjectName 'trialTypeList.mat']);
        load(trialTypeFileName,'trialTypeList');
        
        sessionNumList = [];
        trialNumList   = [];
        for i=1:max(sessionNumListTMP)
            sessionPos     = find(sessionNumListTMP==i);
            sessionNumList = cat(2,sessionNumList,sessionNumListTMP(sessionPos));
            trialNumList   = cat(2,trialNumList,sort(trialNumListTMP(sessionPos)));
        end
        
        numTotalTrials  = length(sessionNumList);
        trialTypeList1D = zeros(1,numTotalTrials);
        for i=1:numTotalTrials
            trialTypeList1D(i) = trialTypeList(sessionNumList(i),trialNumList(i));
        end
        
        %------  It has got the trialtype list here. You can sort the list
        % here itself  ------% 
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Initilising variables for output %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        powerVsTimeList                         = []; % Alpha Power as a function of time
        deltaPowerVsTimeList                    = []; % baseline substracted Alpha Power as a function of time
        EX_mean_deltaPowerVsTimeList_valid      = []; % For (1)Valid trials:    Delta alpha power as a function of time
        EX_mean_deltaPowerVsTimeList_invalid    = []; % For (2)Invalid trials:  Delta alpha power as a function of time
        EX_mean_deltaPowerVsTimeList_constant   = []; % For (3)Constant trials: Delta alpha power as a function of time
        calibrationPowerList          = []; % Calibration power
        meanEyeOpenPowerList          = []; % Mean alpha power during Eye Open condition
        semEyeOpenPowerList           = []; % sem of alpha power during Eye Open condition
        meanEyeClosedPowerList        = []; % Mean alpha power during Eye Closed condition
        semEyeClosedPowerList         = []; % sem of alpha power during Eye Closed condition
        SubPValTemp                   = [];
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        for i=1:numTotalTrials
            calibrationData     = load(fullfile(folderName,[subjectName 'CalibrationProcessedData' 'Session' num2str(sessionNumList(i)) '.mat']));
            analysisData        = load(fullfile(folderName,[subjectName 'ProcessedData' 'Session' num2str(sessionNumList(i)) 'Trial' num2str(trialNumList(i)) '.mat']));
            powerVsTimeTMP      = log10(mean(analysisData.tfData(analysisData.alphaPos,:),1));
            
            meanCalibrationPower = mean(log10(mean(calibrationData.tfData(calibrationData.alphaPos,calibrationData.timePosCalibration),1)));
            
            deltaPowerVsTimeTMP = 10*(powerVsTimeTMP - repmat(meanCalibrationPower,1,50));
            
            meanEyeOpenPower     = mean(powerVsTimeTMP(calibrationData.timePosCalibration));
            semEyeOpenPower      = std(powerVsTimeTMP(calibrationData.timePosCalibration))/sqrt(length(calibrationData.timePosCalibration));
            meanEyeClosedPower   = mean(powerVsTimeTMP(analysisData.timePosAnalysis));
            semEyeClosedPower    = std(powerVsTimeTMP(analysisData.timePosAnalysis))/sqrt(length(analysisData.timePosAnalysis));
            
            calibrationPowerList   = cat(2,calibrationPowerList,meanCalibrationPower);
            powerVsTimeList        = cat(1,powerVsTimeList,powerVsTimeTMP);
            deltaPowerVsTimeList   = cat(1,deltaPowerVsTimeList,deltaPowerVsTimeTMP);
            meanEyeOpenPowerList   = cat(2,meanEyeOpenPowerList,meanEyeOpenPower);
            semEyeOpenPowerList    = cat(2,semEyeOpenPowerList,semEyeOpenPower);
            meanEyeClosedPowerList = cat(2,meanEyeClosedPowerList,meanEyeClosedPower);
            semEyeClosedPowerList  = cat(2,semEyeClosedPowerList,semEyeClosedPower);
        end
        
        timeVals = analysisData.timeValsTF;
        timePosAnalysis = analysisData.timePosAnalysis;
        
        if displayResultsFlag
            % Plot Data
            titleStr='';
            
            %         hold(analysisPlotHandles.powerVsTrial,'on');
            %         errorbar(analysisPlotHandles.powerVsTrial,meanEyeOpenPowerList,semEyeOpenPowerList,'color','k','marker','o');
            %         errorbar(analysisPlotHandles.powerVsTrial,meanEyeClosedPowerList,semEyeClosedPowerList,'color','k','marker','V');
            %         plot(analysisPlotHandles.powerVsTrial,calibrationPowerList,'color','k');
            
            %         hold(analysisPlotHandles.diffPowerVsTrial,'on');
            %         hold(PlotH,'on');
            %         hold(analysisPlotHandles.barPlot,'on');
            
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
                % Trialpositions from 13 to 60 are relavants; defining this
                % as relavantTraialPos:
                
                shortPosList = startTrialTimePos:60;
                relevantTrialPos = trialTypeList1D(shortPosList);
                
                % Making a new triallist where we would replace 2 and 3's
                % as 0's. 
                
                NewRelevantTrialPos = zeros(1,length(relevantTrialPos)); 
                
                % Now assigning 0's and 1's:
                
                for i=1:length(relevantTrialPos)
                    if relevantTrialPos(i)==1
                        NewRelevantTrialPos(i)=1;
                    else 
                        NewRelevantTrialPos(i)=0;
                    end
                end
                
                % Now separating out three different trial-types from
                % NewRelevantTrialPos:
                
                % Defining first, second and third trialtypes:
                    % First:  Trials preceded  by valid(1) trials.
                    % Second: Trials preceded by invalid or constant(0) trial types.
                    % Third:  Trials preceeded by more than one valid trials.
                
                [First_catTrialPos,Second_catTrialPos,Third_catTrialPos] = biofeedbackValidSeparateTrialPos(NewRelevantTrialPos,1);                
                  
                % Now would check whether the sorting is right or not::::
                % Done -> Its right only. 
                
                % Now lets plot only for valid trials for each subjects: 
                
                
             
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%           
            % Modify here to generate separate data matrix for delta power according to Trial types
%             h=[];
            for i=4:-1:1 % Trial Type:  Valid: 1, Invalid: 2, Constant: 3;
                %             trialPos = find(trialTypeList1D==i);
%                 shortPosList = startTrialTimePos:60; % this now becomes redundant -> commenting out. 
                
                % Now would three different trials: 
                
%                 trialPos     = shortPosList(trialTypeList1D(shortPosList)==i);
                
                
                %             if i==3 % no mod required
                %                 titleStr = cat(2,titleStr,[typeNameList{i} '=' num2str(length(trialPos))]);
                %             else
                %                 titleStr = cat(2,titleStr,[typeNameList{i} '=' num2str(length(trialPos)) ', ']);
                %             end
                
%                 if ~isempty(NewRelevantTrialPos)
                    % Power versus Trial
                    %                 errorbar(analysisPlotHandles.powerVsTrial,trialPos,meanEyeOpenPowerList(trialPos),semEyeOpenPowerList(trialPos),'color',colorNames(i),'marker','o','linestyle','none');
                    %                 errorbar(analysisPlotHandles.powerVsTrial,trialPos,meanEyeClosedPowerList(trialPos),semEyeClosedPowerList(trialPos),'color',colorNames(i),'marker','V','linestyle','none');
                    %
                    % Change in Power versus Trial, separated by trialType
                    %                 deltaPower = meanEyeClosedPowerList(trialPos)-calibrationPowerList(trialPos);
                    %                 errorbar(analysisPlotHandles.diffPowerVsTrial,deltaPower,semEyeClosedPowerList(trialPos),'color',colorNames(i),'marker','V');
                    
                    % Power versus time
                    %                 plot(analysisPlotHandles.powerVsTime,analysisData.timeValsTF,mean(powerVsTimeList(trialPos,:),1),'color',colorNames(i));
%                    h(i)= plot(plotH_deltaPowerVsTime,analysisData.timeValsTF,mean(deltaPowerVsTimeList(trialPos,:),1),'color',colorNames(i));
                    %                   ylim(plotH_deltaPowerVsTime,[
                    %%%%%%%%%%% Calculate Report the average value using text at specified position %%%%
                    switch i
                        case 1
                            %                         disp('Trialtype: Valid');
                            trialPos     = First_catTrialPos;
                            h(i)= plot(plotH_deltaPowerVsTime,analysisData.timeValsTF,mean(deltaPowerVsTimeList(trialPos,:),1),'color',colorNames(i));
                            deltaPowerVsTimeList_valid      = deltaPowerVsTimeList(trialPos,:);
                            mean_deltaPowerVsTimeList_valid = mean(deltaPowerVsTimeList_valid,1);
                            EX_mean_deltaPowerVsTimeList_valid = mean_deltaPowerVsTimeList_valid(timePosAnalysis);
                            %                         text(plotH_deltaPowerVsTime,30,1.6,num2str(mean(EX_mean_deltaPowerVsTimeList_valid)),'Color','red','FontSize',8);
                            if subInd == 1 || subInd == 4|| subInd == 5|| subInd == 2 || subInd == 9 || subInd == 17 || subInd == 21 
                                text(0.3,0.12,num2str(mean(EX_mean_deltaPowerVsTimeList_valid),'%.2f'),'Color',colorNames(i),'fontsize',fontSizeVal,'fontweight','bold','unit','normalized','parent',plotH_deltaPowerVsTime);
                            else
                                text(0.3,0.12,num2str(mean(EX_mean_deltaPowerVsTimeList_valid),'%.2f'),'Color',colorNames(i),'fontsize',fontSizeVal,'fontweight','bold','unit','normalized','parent',plotH_deltaPowerVsTime);
                            end
                            
                            if(length(trialPos)==9 || length(trialPos)==6)
                                text(0.35,0.9,strcat(num2str(length(trialPos)),';'),'Color',colorNames(i),'fontsize',fontSizeVal,'fontweight','bold','unit','normalized','parent',plotH_deltaPowerVsTime);
                                text(0.2,0.9,'n = ','Color',colorNames(i),'fontsize',fontSizeVal,'fontweight','bold','unit','normalized','parent',plotH_deltaPowerVsTime);
                            else
                                text(0.15,0.9,'n = ','Color',colorNames(i),'fontsize',fontSizeVal,'fontweight','bold','unit','normalized','parent',plotH_deltaPowerVsTime);
                                text(0.3,0.9,strcat(num2str(length(trialPos)),';'),'Color',colorNames(i),'fontsize',fontSizeVal,'fontweight','bold','unit','normalized','parent',plotH_deltaPowerVsTime);
                            end
                            hold(plotH_deltaPowerVsTime,'on');
                        case 2
                            %                         disp('Traialtype: Invalid');
                            trialPos     = Second_catTrialPos;
                            h(i)= plot(plotH_deltaPowerVsTime,analysisData.timeValsTF,mean(deltaPowerVsTimeList(trialPos,:),1),'color',colorNames(i));
                            deltaPowerVsTimeList_invalid      = deltaPowerVsTimeList(trialPos,:);
                            mean_deltaPowerVsTimeList_invalid = mean(deltaPowerVsTimeList_invalid,1);
                            EX_mean_deltaPowerVsTimeList_invalid = mean_deltaPowerVsTimeList_invalid(timePosAnalysis);
                            if subInd == 3 || subInd == 8|| subInd == 12
                                text(0.57,0.12,num2str(mean(EX_mean_deltaPowerVsTimeList_invalid),'%.2f'),'Color',colorNames(i),'fontsize',fontSizeVal,'fontweight','bold','unit','normalized','parent',plotH_deltaPowerVsTime);
                            else
                                text(0.55,0.12,num2str(mean(EX_mean_deltaPowerVsTimeList_invalid),'%.2f'),'Color',colorNames(i),'fontsize',fontSizeVal,'fontweight','bold','unit','normalized','parent',plotH_deltaPowerVsTime);
                            end
                            text(0.45,0.9,strcat(num2str(length(trialPos)),';'),'Color',colorNames(i),'fontsize',fontSizeVal,'fontweight','bold','unit','normalized','parent',plotH_deltaPowerVsTime);
                        case 3
                            %                         disp('Trailtype: Constant');
                            trialPos     = Third_catTrialPos;
                            h(i)= plot(plotH_deltaPowerVsTime,analysisData.timeValsTF,mean(deltaPowerVsTimeList(trialPos,:),1),'color',colorNames(i));
                            deltaPowerVsTimeList_constant = deltaPowerVsTimeList(trialPos,:);
                            mean_deltaPowerVsTimeList_constant = mean(deltaPowerVsTimeList_constant,1);
                            EX_mean_deltaPowerVsTimeList_constant = mean_deltaPowerVsTimeList_constant(timePosAnalysis);
                            if subInd == 1 || subInd == 4|| subInd == 5|| subInd == 2 || subInd == 9 || subInd == 17 || subInd == 21 
                                text(0.8,0.12,num2str(mean(EX_mean_deltaPowerVsTimeList_constant),'%.2f'),'Color',colorNames(i),'fontsize',fontSizeVal,'fontweight','bold','unit','normalized','parent',plotH_deltaPowerVsTime);
                            else
                                text(0.8,0.12,num2str(mean(EX_mean_deltaPowerVsTimeList_constant),'%.2f'),'Color',colorNames(i),'fontsize',fontSizeVal,'fontweight','bold','unit','normalized','parent',plotH_deltaPowerVsTime);
                            end
                            text(0.6,0.9,num2str(length(trialPos)),'Color',colorNames(i),'fontsize',fontSizeVal,'fontweight','bold','unit','normalized','parent',plotH_deltaPowerVsTime);
                            %                     otherwise
                        case 4
                            validTrialPos = [First_catTrialPos,Second_catTrialPos,Third_catTrialPos];
                            sortValidTrialPos = sort(validTrialPos); 
                            plot(plotH_deltaPowerVsTime,analysisData.timeValsTF,mean(deltaPowerVsTimeList(sortValidTrialPos,:),1),'color',[0 0 0]);
                    
                           
                    end
                    
%                
                    hold(plotH_deltaPowerVsTime,'on');
                    % Update the axis names
                    
                    % Bar Plot
                    %                 bar(analysisPlotHandles.barPlot,i,mean(deltaPower),colorNames(i));
                    %                 errorbar(analysisPlotHandles.barPlot,i,mean(deltaPower),std(deltaPower)/sqrt(length(deltaPower)),'color',colorNames(i));
                    %                 disp(mean(deltaPower));
                    
                    
%                 end
                
            end
            
            if subInd == 6
                legend([h(1) h(2) h(3)],{'Valid Type 1','Valid Type 2','Valid Type 3',},'Orientation','horizontal','Box','on','FontSize',12,'Units','Normalized','Location','northoutside');
            end
            
            %%%%%%%%%%% Calculate and Report the p value between valid and invalid calucula%%%%
%             [h,pval1] = ttest2(EX_mean_deltaPowerVsTimeList_valid,EX_mean_deltaPowerVsTimeList_invalid,'Alpha',0.05,'Tail','right','Vartype','unequal');
%             SubPValTemp  = pval1;
            
            %         text(0.6,0.9,['p<10^{' ceil(log10(pval1)) '}' ],'color',[0 0 0],'fontsize',10,'fontweight','bold','normalized','parent',plotH_deltaPowerVsTime);
            %         if pval1<0.01
            %              text(0.6,0.9,['p < 10^{' num2str(ceil(log10(pval1))) '}'],'color',[1 0.2695 0],'fontsize',fontSizeVal+2,'fontweight','bold','unit','normalized','parent',plotH_deltaPowerVsTime);
            %         else
            %             phVal = num2str(pval1,'%.3f');
            %             text(0.6,0.9,['p = ' phVal],'Color',[1 0.2695 0],'fontsize',fontSizeVal+2,'fontweight','bold','unit','normalized','parent',plotH_deltaPowerVsTime);
            %         end
            
%             if subInd < 7
%                 disp(pval1);
%                 pval_pow = ceil(log10(pval1))-1;
%                 pval_ini = pval1*10^abs(pval_pow);                
%                 text(0.47,0.9,['p = ' num2str(pval_ini,'%.2f') '\times' '10^{' num2str(pval_pow) '}'],'color',[0 0 0],'fontsize',fontSizeVal,'fontweight','bold','unit','normalized','parent',plotH_deltaPowerVsTime);
%             else
%                 phVal = num2str(pval1,'%.3f');
%                 text(0.57,0.9,['p = ' phVal],'Color',[0 0 0],'fontsize',fontSizeVal,'fontweight','bold','unit','normalized','parent',plotH_deltaPowerVsTime);
%             end
            
            %         disp(pval1);
            %         s1 = num2str(pval1,'%.3f'); s2 = ','; s3 = num2str(h);
            %         phVal = strcat(s1,s2,s3);
            %         text(0.9,0.9,phVal,'Color',[1 0.2695 0],'fontsize',10,'fontweight','bold','unit','normalized','parent',plotH_deltaPowerVsTime);
            
            %         title(analysisPlotHandles.powerVsTrial,titleStr);
            %         xlim(analysisPlotHandles.barPlot,[0.5 3.5]);
            %         set(analysisPlotHandles.barPlot,'XTick',1:3,'XTickLabel',typeNameList);
            %         if subInd <19
            %             set(plotH_deltaPowerVsTime,'xticklabel',[]);
            %         end
            ylim(plotH_deltaPowerVsTime,[-5 20]);
            drawnow;
        end
    end
    
    if subInd <19
        set(plotH_deltaPowerVsTime,'xticklabels',[]);
        set(plotH_deltaPowerVsTime,'yticklabels',[]);
        set(plotH_deltaPowerVsTime,'ylabel',[]);
    else
        set(plotH_deltaPowerVsTime,'xticklabelmode','auto');
    end
    
%     if subInd ==6
%         legend([h(1) h(2) h(3)],{'Valid trial','Invalid trial','Constant trial',},'Orientation','horizontal','Box','on','FontSize',10,'Units','Normalized','Location','northeast');
%     end
%    
test = 10;
end