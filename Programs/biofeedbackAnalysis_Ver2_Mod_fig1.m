% This program is used to analysize the results of the alpha feedback project.
% Input - subjectName: A string to identify the subject.

function [analysisPlotHandles,colorNames,meanEyeOpenPowerList,meanEyeClosedPowerList,calibrationPowerList,trialTypeList1D,powerVsTimeList,timeVals,typeNameList] = biofeedbackAnalysis_Ver2_Mod_fig1(subjectName,folderName,displayResultsFlag,analysisPlotHandles)
    
    if ~exist('subjectName','var');         subjectName='';                 end
    if ~exist('folderName','var');          folderName='';                  end
    if ~exist('displayResultsFlag','var');  displayResultsFlag  = 1;        end
    if ~exist('analysisPlotHandles','var'); analysisPlotHandles = [];       end
    if ~exist('fontSizeVal','var');         fontSizeVal = 12;               end
    if ~exist('startTrialTimePos','var');   startTrialTimePos = 13;         end
    
    if isempty(folderName)
        pathStr     = fileparts(pwd);
        folderName  = fullfile(pathStr,'Data',subjectName);
    end
    
    if isempty(analysisPlotHandles)
        
        % chnged this to have all the figured positioned accordingly in one
        % figure itslef from the latewr one where it was one the lower half.
        
        analysisPlotHandles.powerVsTrial    = subplot(2,2,1);
        analysisPlotHandles.powerVsTime     = subplot(2,2,2);
        %         analysisPlotHandles.barPlot         = subplot(2,2,4);
        
        
        %     analysisPlotHandles.powerVsTrial = subplot(2,2,1);
        %     analysisPlotHandles.diffPowerVsTrial = subplot(2,2,3);
        %     analysisPlotHandles.powerVsTime = subplot(2,2,2);
        %     analysisPlotHandles.barPlot = subplot(2,2,4);
        
        %     analysisPlotHandles.powerVsTrial = subplot('Position',[0.05 0.3 0.4 0.2]);
        %     analysisPlotHandles.diffPowerVsTrial = subplot('Position',[0.05 0.05 0.4 0.2]);
        %     analysisPlotHandles.powerVsTime = subplot('Position',[0.55 0.3 0.4 0.2]);
        %     analysisPlotHandles.barPlot = subplot('Position',[0.55 0.05 0.4 0.2]);
        
    else
        % Clear all plots
        cla(analysisPlotHandles.powerVsTrial);
        %     cla(analysisPlotHandles.diffPowerVsTrial);
        cla(analysisPlotHandles.powerVsTime);
        %         cla(analysisPlotHandles.barPlot);
    end
    
    colorNames      = 'rgb';
    typeNameList{1} ='Valid';
    typeNameList{2} ='Invalid';
    typeNameList{3} ='Constant';
    
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
        deltaPowerVsTimeList   = [];
        
        for i=1:numTotalTrials
            calibrationData = load(fullfile(folderName,[subjectName 'CalibrationProcessedData' 'Session' num2str(sessionNumList(i)) '.mat']));
            analysisData    = load(fullfile(folderName,[subjectName 'ProcessedData' 'Session' num2str(sessionNumList(i)) 'Trial' num2str(trialNumList(i)) '.mat']));
            powerVsTimeTMP  = log10(mean(analysisData.tfData(analysisData.alphaPos,:),1));
            
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
        
        if displayResultsFlag
            % Plot Data
            titleStr='';
            
            hold(analysisPlotHandles.powerVsTrial,'on');
            
            % Power versus Trial without any specific trial type indication:
            
            trialno = 1:60;
            %             errorbar(analysisPlotHandles.powerVsTrial,trialno,meanEyeOpenPowerList,semEyeOpenPowerList,'color','k','marker','o','linewidth',0.9);
            %             errorbar(analysisPlotHandles.powerVsTrial,trialno,meanEyeClosedPowerList,semEyeClosedPowerList,'color','k','marker','V','linewidth',0.9);
            hold(analysisPlotHandles.powerVsTime,'on');
            %             plot(analysisPlotHandles.powerVsTrial,trialno,meanEyeOpenPowerList,'-','color','y','linewidth',2);
            %             plot(analysisPlotHandles.powerVsTrial,trialno,meanEyeClosedPowerList,'color',[1 0.4961 0.3125],'linewidth',2);
            %------------ Regression for power vs eyes closed power:
            lmPowerVsTrial_1 = fitlm(trialno(13:60),meanEyeOpenPowerList(13:60),'linear');
            lmPowerVsTrial_2 = fitlm(trialno(13:60),meanEyeClosedPowerList(13:60),'linear');
            text(0.18,0.98,'Eyes closed,','Color',[0.6445 0.1641 0.1641],'fontsize',fontSizeVal,'fontweight','bold','unit','normalized','parent',analysisPlotHandles.powerVsTrial);
            text(0.68,0.98,['     p = ' num2str(lmPowerVsTrial_2.Coefficients{2,4},'%.3f')],'Color',[0.6445 0.1641 0.1641],'fontsize',fontSizeVal,'fontweight','bold','unit','normalized','parent',analysisPlotHandles.powerVsTrial);
            %             text(0.67,0.96,['\beta_{2} = ' num2str(lmPowerVsTrial_2.Coefficients{2,1},'%.3f')],'Color',[0.6445 0.1641 0.1641],'fontsize',fontSizeVal,'fontweight','bold','unit','normalized','parent',analysisPlotHandles.powerVsTrial);
            text(0.4,0.98,['    Slope = ' num2str(lmPowerVsTrial_2.Coefficients{2,1},'%.3f') ','],'Color',[0.6445 0.1641 0.1641],'fontsize',fontSizeVal,'fontweight','bold','unit','normalized','parent',analysisPlotHandles.powerVsTrial);
            %             text(0.21,0.93,['p = ' num2str(lmPowerVsTrial_1.Coefficients{2,4},'%.3f')],'Color',[0.6602 0.6602 0.6602],'fontsize',fontSizeVal,'fontweight','bold','unit','normalized','parent',analysisPlotHandles.powerVsTrial);
            %             text(0.1,0.98,['Slope = ' num2str(lmPowerVsTrial_1.Coefficients{2,1},'%.3f')],'Color',[0.6602 0.6602 0.6602],'fontsize',fontSizeVal,'fontweight','bold','unit','normalized','parent',analysisPlotHandles.powerVsTrial);
            text(0.18,0.05,'Eyes open,','Color',[0.6602 0.6602 0.6602],'fontsize',fontSizeVal,'fontweight','bold','unit','normalized','parent',analysisPlotHandles.powerVsTrial);
            text(0.68,0.05,['  p = ' num2str(lmPowerVsTrial_1.Coefficients{2,4},'%.3f')],'Color',[0.6602 0.6602 0.6602],'fontsize',fontSizeVal,'fontweight','bold','unit','normalized','parent',analysisPlotHandles.powerVsTrial);
            text(0.4,0.05,[' Slope = ' num2str(lmPowerVsTrial_1.Coefficients{2,1},'%.3f') ','],'Color',[0.6602 0.6602 0.6602],'fontsize',fontSizeVal,'fontweight','bold','unit','normalized','parent',analysisPlotHandles.powerVsTrial);

            xfit = 13:1:60;
%             xfit = min(trialno):1:max(trialno);
            YFIT = lmPowerVsTrial_1.Coefficients{1,1} + lmPowerVsTrial_1.Coefficients{2,1}*xfit;
            YFIT_2 = lmPowerVsTrial_2.Coefficients{1,1} + lmPowerVsTrial_2.Coefficients{2,1}*xfit;
            plot(analysisPlotHandles.powerVsTrial,xfit,YFIT,'color',[0.6602 0.6602 0.6602],'linewidth',4);
            plot(analysisPlotHandles.powerVsTrial,xfit,YFIT_2,'color',[0.6445 0.1641 0.1641],'linewidth',4);
            plot(analysisPlotHandles.powerVsTrial,calibrationPowerList,'color',[0 0 0],'linewidth',2);
            
            % shadedErrorBar(trialno,meanEyeClosedPowerList,semEyeClosedPowerList,'-k',1);
            
            %         hold(analysisPlotHandles.diffPowerVsTrial,'on');
            %             hold(analysisPlotHandles.powerVsTime,'on');
            %             hold(analysisPlotHandles.barPlot,'on');
            for i=3:-1:1 % Trial Type
                trialPosRawPower = find(trialTypeList1D==i);
                shortPosList = startTrialTimePos:60;
                trialPos = shortPosList(trialTypeList1D(shortPosList)==i);
                
                %                 if i==1
                %                     titleStr = cat(2,titleStr,[typeNameList{i} '=' num2str(length(trialPos))]);
                %                 else
                %                     titleStr = cat(2,titleStr,[typeNameList{i} '=' num2str(length(trialPos)) ', ']);
                %                 end
                
                if ~isempty(trialPos)
                    % Power versus Trial
                    errorbar(analysisPlotHandles.powerVsTrial,trialPosRawPower,meanEyeOpenPowerList(trialPosRawPower),semEyeOpenPowerList(trialPosRawPower),'color',colorNames(i),'marker','o','linestyle','none','MarkerSize',8,'MarkerFaceColor','w');
                    errorbar(analysisPlotHandles.powerVsTrial,trialPosRawPower,meanEyeClosedPowerList(trialPosRawPower),semEyeClosedPowerList(trialPosRawPower),'color',colorNames(i),'marker','V','linestyle','none','MarkerSize',8,'MarkerFaceColor',colorNames(i));
                    
                    % Change in Power versus Trial, separated by trialType
                    %                 deltaPower = meanEyeClosedPowerList(trialPos)-calibrationPowerList(trialPos);
                    deltaPower              = deltaPowerVsTimeList(trialPos,:);
                    mean_deltaPower         = mean(deltaPower,1);
                    EX_mean_deltaPower      = mean_deltaPower(21:50);
                    sem_EX_mean_deltaPower  = std(EX_mean_deltaPower)/sqrt(length(EX_mean_deltaPower)); 
                    %                 errorbar(analysisPlotHandles.diffPowerVsTrial,deltaPower,semEyeClosedPowerList(trialPos),'color',colorNames(i),'marker','V');
                    
                    % Power versus time
                    tempmeanPower = mean(deltaPower,1);
                    plot(analysisPlotHandles.powerVsTime,analysisData.timeValsTF(6:end),tempmeanPower(6:end),'color',colorNames(i),'LineWidth',2);
                    
                    %------------------------------------------------------
                    switch i
                        case 1
                            % Fit a regression line using regress
                            % Report P value and r value of the regression
                            % line using text
                            %                             meanAllSubmeanEyeOpenPowerList = mean(meanEyeOpenPowerList);
                            timeAxis = 21:50;
                            x   = timeAxis';
                            X   = [ones(size(x)) x];
                            y   = EX_mean_deltaPower';
                            lm  = fitlm(x,y,'linear');
                            [b,~,~,~,stats] = regress(y,X,0.01);
                            %                             b = regress(y,X);
                            xfit = min(x):1:max(x);
                            YFIT = lm.Coefficients{1,1} + lm.Coefficients{2,1}*xfit;
                            p_value_regress = stats(3);
                            slope_value_regress = b(2);
                            %                             scatter(hRawPowerVsTrials,trialaxis,meanEyeClosedPowerList(i,:),'.','k')
                            plot(analysisPlotHandles.powerVsTime,xfit,YFIT,'color',colorNames(i),'linewidth',4);
                            text(0.64,0.3,[' p = ' num2str(p_value_regress,'%.3f')],'Color',colorNames(i),'fontsize',fontSizeVal,'fontweight','bold','unit','normalized','parent',analysisPlotHandles.powerVsTime);
                            %                             text(0.7,0.25,['R^{2} = ' num2str(r_value_regress,'%.3f')],'Color',[0,0,0],'fontsize',fontSizeVal,'fontweight','bold','unit','normalized','parent',analysisPlotHandles.powerVsTime);
                            text(0.35,0.3,['Slope = ' num2str(slope_value_regress,'%.3f') ','],'Color',colorNames(i),'fontsize',fontSizeVal,'fontweight','bold','unit','normalized','parent',analysisPlotHandles.powerVsTime);
%                              text(0.7,0.36,['\beta_{1} = ' num2str(lm.Coefficients{2,1},'%.3f')],'Color',colorNames(i),'fontsize',fontSizeVal,'fontweight','bold','unit','normalized','parent',analysisPlotHandles.powerVsTime);
                            text(0.7,0.95,[num2str(mean(EX_mean_deltaPower),'%.2f') '\pm' num2str(sem_EX_mean_deltaPower,'%.2f')],'Color',colorNames(i),'fontsize',fontSizeVal,'fontweight','bold','unit','normalized','parent',analysisPlotHandles.powerVsTime);
                        case 2
                            timeAxis = 21:50;
                            x   = timeAxis';
                            X   = [ones(size(x)) x];
                            y   = EX_mean_deltaPower';
                            lm  = fitlm(x,y,'linear');
                            [b,~,~,~,stats] = regress(y,X,0.01);
                            %                             b = regress(y,X);
                            xfit = min(x):1:max(x);
                            YFIT = lm.Coefficients{1,1} + lm.Coefficients{2,1}*xfit;
                            p_val_slope = lm.Coefficients{2,4};
                            p_value_regress = stats(3);
                            slope_value_regress = b(2);
                            %                             scatter(hRawPowerVsTrials,trialaxis,meanEyeClosedPowerList(i,:),'.','k')
                            plot(analysisPlotHandles.powerVsTime,xfit,YFIT,'color',colorNames(i),'linewidth',4);
%                             disp(pval1);
                            pval_pow = ceil(log10(p_value_regress))-1;
                            pval_ini = p_val_slope*10^abs(pval_pow);
                            text(0.64,0.23,[' p = ' num2str(pval_ini,'%.2f') '\times' '10^{' num2str(pval_pow) '}'],'color',colorNames(i),'fontsize',fontSizeVal,'fontweight','bold','unit','normalized','parent',analysisPlotHandles.powerVsTime);
%                             text(0.7,0.23,[', p < 10^{' num2str(ceil(log10(p_val_slope))) '}'],'Color',colorNames(i),'fontsize',fontSizeVal,'fontweight','bold','unit','normalized','parent',analysisPlotHandles.powerVsTime);
                            %                             text(0.7,0.25,['R^{2} = ' num2str(r_value_regress,'%.3f')],'Color',[0,0,0],'fontsize',fontSizeVal,'fontweight','bold','unit','normalized','parent',analysisPlotHandles.powerVsTime);
%                             text(0.7,0.25,['\beta_{1} = ' num2str(lm.Coefficients{2,1},'%.3f')],'Color',colorNames(i),'fontsize',fontSizeVal,'fontweight','bold','unit','normalized','parent',analysisPlotHandles.powerVsTime);
                            text(0.35,0.23,['Slope = ' num2str(slope_value_regress,'%.3f') ','],'Color',colorNames(i),'fontsize',fontSizeVal,'fontweight','bold','unit','normalized','parent',analysisPlotHandles.powerVsTime);
                            text(0.7,0.9,[num2str(mean(EX_mean_deltaPower),'%.2f') '\pm' num2str(sem_EX_mean_deltaPower,'%.2f')],'Color',colorNames(i),'fontsize',fontSizeVal,'fontweight','bold','unit','normalized','parent',analysisPlotHandles.powerVsTime);
                        case 3
                            timeAxis = 21:50;
                            x   = timeAxis';
                            X   = [ones(size(x)) x];
                            y   = EX_mean_deltaPower';
                            lm  = fitlm(x,y,'linear');
                            [b,~,~,~,stats] = regress(y,X,0.01);
                            %                             b = regress(y,X);
                            xfit = min(x):1:max(x);
                            YFIT = lm.Coefficients{1,1} + lm.Coefficients{2,1}*xfit;
                            p_val_slope = lm.Coefficients{2,4};
                            p_value_regress = stats(3);
                            slope_value_regress = b(2);
                            %                             scatter(hRawPowerVsTrials,trialaxis,meanEyeClosedPowerList(i,:),'.','k')
                            plot(analysisPlotHandles.powerVsTime,xfit,YFIT,'color',colorNames(i),'linewidth',4);
                             pval_pow = ceil(log10(p_value_regress))-1;
                            pval_ini = p_val_slope*10^abs(pval_pow);
                            text(0.64,0.16,[' p = ' num2str(pval_ini,'%.2f') '\times' '10^{' num2str(pval_pow) '}'],'color',colorNames(i),'fontsize',fontSizeVal,'fontweight','bold','unit','normalized','parent',analysisPlotHandles.powerVsTime);                         
                            
%                             text(0.7,0.16,[', p < 10^{' num2str(ceil(log10(p_val_slope))) '}'],'Color',colorNames(i),'fontsize',fontSizeVal,'fontweight','bold','unit','normalized','parent',analysisPlotHandles.powerVsTime);
                            %                             text(0.7,0.25,['R^{2} = ' num2str(r_value_regress,'%.3f')],'Color',[0,0,0],'fontsize',fontSizeVal,'fontweight','bold','unit','normalized','parent',analysisPlotHandles.powerVsTime);
%                             text(0.7,0.15,['\beta_{1} = ' num2str(lm.Coefficients{2,1},'%.3f')],'Color',colorNames(i),'fontsize',fontSizeVal,'fontweight','bold','unit','normalized','parent',analysisPlotHandles.powerVsTime);
                            text(0.35,0.16,['Slope = ' num2str(slope_value_regress,'%.3f') ','],'Color',colorNames(i),'fontsize',fontSizeVal,'fontweight','bold','unit','normalized','parent',analysisPlotHandles.powerVsTime);
                            text(0.7,0.85,[num2str(mean(EX_mean_deltaPower),'%.2f' ) '\pm' num2str(sem_EX_mean_deltaPower,'%.2f')],'Color',colorNames(i),'fontsize',fontSizeVal,'fontweight','bold','unit','normalized','parent',analysisPlotHandles.powerVsTime);
                    end
                    
                    % Bar Plot
                    %                     bar(analysisPlotHandles.barPlot,i,mean(EX_mean_deltaPower),colorNames(i));
                    %                     errorbar(analysisPlotHandles.barPlot,i,mean(EX_mean_deltaPower),std(EX_mean_deltaPower)/sqrt(length(EX_mean_deltaPower)),'color',colorNames(i));
                    %                     disp(mean(EX_mean_deltaPower));
                end
            end
            title(analysisPlotHandles.powerVsTrial,titleStr);
            %             xlim(analysisPlotHandles.barPlot,[0.5 3.5]);
            %             set(analysisPlotHandles.barPlot,'XTick',1:3,'XTickLabel',typeNameList);
            hold(analysisPlotHandles.powerVsTime,'off');
            %             hold(analysisPlotHandles.barPlot,'off');
            drawnow;
        end
    end