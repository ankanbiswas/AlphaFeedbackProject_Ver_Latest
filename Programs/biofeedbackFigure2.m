function biofeedbackFigure2
    
    % Function to generate figure1
    % Input:
            % Subject name as string
            % foldername (optional)
    
    %%%% Creating figure and axes first:
    hFigure1          = figure(2); % Creating figure
    clf
    %     set(gcf,'Visible', 'off');
    fontsize = 10;
    hRawPowerVsTrials                       = subplot(1,3,1,'Parent',hFigure1);
    title('Raw Power Vs Trials (All Subjects)');
    xlabel(hRawPowerVsTrials,'Trials','fontsize',fontsize,'fontweight','bold');
    ylabel(hRawPowerVsTrials,'Raw Power','fontsize',fontsize,'fontweight','bold');
    
    hNoOfSubjectsVsSlopeValues_EyesOpen     = subplot(1,3,2,'Parent',hFigure1);
    title('Eyes Open');
    xlabel(hNoOfSubjectsVsSlopeValues_EyesOpen,'No Of Subjects','fontsize',fontsize,'fontweight','bold');
    ylabel(hNoOfSubjectsVsSlopeValues_EyesOpen,'Slope Values','fontsize',fontsize,'fontweight','bold');
    
    hNoOfSubjectsVsSlopeValues_EyesClosed   = subplot(1,3,3,'Parent',hFigure1);
    title('Eyes Closed');
    xlabel(hNoOfSubjectsVsSlopeValues_EyesClosed,'No Of Subjects','fontsize',fontsize,'fontweight','bold');
    ylabel(hNoOfSubjectsVsSlopeValues_EyesClosed,'Slope Values','fontsize',fontsize,'fontweight','bold');
  
    % list of subjects
    subjectNames = {'ABA','AJ','DB','DD','HS','SB','SG','SS','SSH','SKS','KNB','SSA','SHG','MP','MJR','ARC','TBR','BPP','SL','PK','PB','PM','SKH','AD'};
    numSubjects  = length(subjectNames);
    hold(hRawPowerVsTrials,'on');
    trialaxis = 1:60;
    for i=1:numSubjects
        disp(i);
        [meanEyeOpenPowerList(i,:),semEyeOpenPowerList(i,:),meanEyeClosedPowerList(i,:),semEyeClosedPowerList(i,:),calibrationPowerList(i,:),trialTypeList1D(i,:),timeVals,typeNameList] = biofeedbackAnalysis_Ver2_Mod_fig2(subjectNames{i},'');
        %          [analysisPlotHandles,colorNames,meanEyeOpenPowerList(i,:),meanEyeClosedPowerList(i,:),calibrationPowerList(i,:),trialTypeList1D(i,:),powerVsTimeList(i,:,:),timeVals,typeNameList] = biofeedbackAnalysis_Ver2(subjectNames{i},'',0,[]);
        scatter(hRawPowerVsTrials,trialaxis,meanEyeOpenPowerList(i,:),'.','k');
%         lsline(hRawPowerVsTrials);
        % quick regress analysis using the data and plotting for the
        % specific subject:
        x = trialaxis';
        X = [ones(size(x)) x];
        y = meanEyeOpenPowerList(i,:)';
        b = regress(y,X);
        xfit = min(x):1:max(x);
        YFIT = b(1) + b(2)*xfit;
        plot(hRawPowerVsTrials,xfit,YFIT,'r');
        
%         scatter(hRawPowerVsTrials,trialaxis,meanEyeClosedPowerList(i,:),'.','k');
%         x2 = trialaxis';
%         X2 = [ones(size(x2)) x2];
%         y2 = meanEyeClosedPowerList(i,:)';
%         b2 = regress(y,X);
%         xfit2 = min(x):1:max(x);
%         YFIT2 = b2(1) + b2(2)*xfit2;
%         plot(hRawPowerVsTrials,xfit2,YFIT2,'b');
        drawnow        
    end
    hold(hRawPowerVsTrials,'off');
    % What we need now is meanEyeOpenPowerList,meanEyeClosedPowerList & calibrationPowerList
    % All are of size 24*60:
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
end