function biofeedbackFigure2
    
    % What we need now is meanEyeOpenPowerList,meanEyeClosedPowerList & calibrationPowerList
    % All are of size 24*60:      
    % Function to generate figure1
    % Input:
            % Subject name as string
            % Foldername (optional)
     
    %%%% Creating figure and axes first:
    
    hFigure1          = figure(2); % Creating figure
    clf
    %   set(gcf,'Visible', 'off');
    
    fontsize = 10;
    hRawPowerVsTrials                       = subplot(1,3,1,'Parent',hFigure1);
    title('Raw Power Vs Trials (All Subjects)');
    xlabel(hRawPowerVsTrials,'Trials','fontsize',fontsize,'fontweight','bold');
    ylabel(hRawPowerVsTrials,'Raw Power','fontsize',fontsize,'fontweight','bold');
    
    hNoOfSubjectsVsSlopeValues_EyesOpen     = subplot(1,3,2,'Parent',hFigure1);
%     title('Eyes Open');
%     xlabel(hNoOfSubjectsVsSlopeValues_EyesOpen,'No Of Subjects','fontsize',fontsize,'fontweight','bold');
%     ylabel(hNoOfSubjectsVsSlopeValues_EyesOpen,'Slope Values','fontsize',fontsize,'fontweight','bold');
    
    hNoOfSubjectsVsSlopeValues_EyesClosed   = subplot(1,3,3,'Parent',hFigure1);
%     title('Eyes Closed');
%     xlabel(hNoOfSubjectsVsSlopeValues_EyesClosed,'No Of Subjects','fontsize',fontsize,'fontweight','bold');
%     ylabel(hNoOfSubjectsVsSlopeValues_EyesClosed,'Slope Values','fontsize',fontsize,'fontweight','bold');
  
    % list of subjects
%     subjectNames = {'ABA','AJ','DB','DD','HS','SB','SG','SS','SSH','SKS','KNB','SSA','SHG','MP','MJR','ARC','TBR','BPP','SL','PK','PB','PM','SKH','AD'};
    
    subjectNames = {'ABA','ARC','DD','AJ','SG',...
                    'MP','PB','SSA','SL','DB', ...
                    'PK','HS','AD','SB','SKS','SS',...
                    'SHG','KNB','BPP','SSH',...
                    'MJR','TBR','SKH','PM'}';
            
    numSubjects  = length(subjectNames);
    hold(hRawPowerVsTrials,'on');
    trialaxis = 13:60;
    AllSubEyeOpenSlope = [];
    AllSubEyeCloseSlope = [];
    
    for i=1:numSubjects
        disp(i);
        [meanEyeOpenPowerList(i,:),semEyeOpenPowerList(i,:),meanEyeClosedPowerList(i,:),semEyeClosedPowerList(i,:),calibrationPowerList(i,:),trialTypeList1D(i,:),timeVals,typeNameList] = biofeedbackAnalysis_Ver2_Mod_fig2(subjectNames{i},'');

        %          [analysisPlotHandles,colorNames,meanEyeOpenPowerList(i,:),meanEyeClosedPowerList(i,:),calibrationPowerList(i,:),trialTypeList1D(i,:),powerVsTimeList(i,:,:),timeVals,typeNameList] = biofeedbackAnalysis_Ver2(subjectNames{i},'',0,[]);
%         scatter(hRawPowerVsTrials,trialaxis,meanEyeOpenPowerList(i,:),'.','k');
%         lsline(hRawPowerVsTrials);

        % quick regress analysis using the data and plotting for the
        % specific subject:
        
        %%% for eyesOpenPower
        x = trialaxis';
        X = [ones(size(x)) x];
        y = meanEyeOpenPowerList(i,:)';
        y = y(13:60);
        b = regress(y,X);
        xfit = min(x):1:max(x);
        YFIT = b(1) + b(2)*xfit;
%         plot(hRawPowerVsTrials,xfit,YFIT,'color',[0.5 0.5 0.5],'linewidth',2);
        
        AllSubEyeOpenSlope = [AllSubEyeOpenSlope; b(2)];
         %%% for eyesClosePower
        
%         scatter(hRawPowerVsTrials,trialaxis,meanEyeClosedPowerList(i,:),'.','k');
        x2 = trialaxis';
        X2 = [ones(size(x2)) x2];
        y2 = meanEyeClosedPowerList(i,:)';
        y2 = y2(13:60);
        b2 = regress(y2,X2);
        xfit2 = min(x2):1:max(x2);
        YFIT2 = b2(1) + b2(2)*xfit2;
%         plot(hRawPowerVsTrials,xfit2,YFIT2,'color',[1 0.625 0.4766],'linewidth',2);
        AllSubEyeCloseSlope = [AllSubEyeCloseSlope; b2(2)];
        
%         drawnow        
    end
    
     %%%%% ploting mean eye open data and regression line %%%%
    
    %------------------------------------------------------------------------
     %%% mean regression for eyesOpenPower
    meanAllSubmeanEyeOpenPowerList = mean(meanEyeOpenPowerList);
    x = trialaxis';
    X = [ones(size(x)) x];
    y = meanAllSubmeanEyeOpenPowerList';
    y = y(13:60);
    b = regress(y,X);
    xfit = min(x):1:max(x);
    YFIT = b(1) + b(2)*xfit;
    
    scatter(hRawPowerVsTrials,trialaxis,meanEyeClosedPowerList(i,13:60),'.','k')
    plot(hRawPowerVsTrials,xfit,YFIT,'color',[0 0 0],'linewidth',4);
    
    %------------------------------------------------------------------------
    %%% mean regression for eyesClosePower
    
    meanAllSubmeanEyeClosePowerList = mean(meanEyeClosedPowerList);
    x = trialaxis';
    X = [ones(size(x)) x];
    y = meanAllSubmeanEyeClosePowerList';
    y = y(13:60);
    b = regress(y,X);
    xfit = min(x):1:max(x);
    YFIT = b(1) + b(2)*xfit;
    plot(hRawPowerVsTrials,xfit,YFIT,'color',[0.6953 0.1328 0.1328],'linewidth',4);
    
    hold(hRawPowerVsTrials,'off');
  
    histBinWidth_1 = (max(AllSubEyeOpenSlope)- min(AllSubEyeOpenSlope))/5;
    histBinWidth_2 = (max(AllSubEyeCloseSlope)- min(AllSubEyeCloseSlope))/5;
    histogram(hNoOfSubjectsVsSlopeValues_EyesOpen, AllSubEyeOpenSlope,'BinWidth',histBinWidth_1);
    histogram(hNoOfSubjectsVsSlopeValues_EyesClosed, AllSubEyeCloseSlope,'BinWidth',histBinWidth_2);
    
    axes(hNoOfSubjectsVsSlopeValues_EyesOpen);
    title('Eyes Open');
    ylabel(hNoOfSubjectsVsSlopeValues_EyesOpen,'No Of Subjects','fontsize',fontsize,'fontweight','bold');
    xlabel(hNoOfSubjectsVsSlopeValues_EyesOpen,'Slope Values','fontsize',fontsize,'fontweight','bold');
    hold(hNoOfSubjectsVsSlopeValues_EyesOpen,'off');
    
    axes(hNoOfSubjectsVsSlopeValues_EyesClosed);
    title('Eyes Closed');
    ylabel(hNoOfSubjectsVsSlopeValues_EyesClosed,'No Of Subjects','fontsize',fontsize,'fontweight','bold');
    xlabel(hNoOfSubjectsVsSlopeValues_EyesClosed,'Slope Values','fontsize',fontsize,'fontweight','bold');
    flag;      
end