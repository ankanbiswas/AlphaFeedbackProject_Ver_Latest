
function biofeedbackFigure1(subjectName,folderName)
    
    % Function to generate figure1
    % Input:
        % Subject name as string
        % foldername (optional)
     
    randomfigurenumber = 100+randi(100); 
    figure(randomfigurenumber);
    
    
    if ~exist('subjectName','var'); subjectName = 'PB'; end
    if ~exist('folderName','var');  folderName  = '';    end
    
    fontSizeVal = 10;
    
    if isempty(folderName)
        pathStr     = fileparts(pwd);
        folderName  = fullfile(pathStr,'Data',subjectName);
    end
    
    hFigure1          = gcf; % Creating 
    
%     set(gcf,'Visible', 'off'); 
    
    hExperimentFlow   = subplot('Position',[0.05 0.9 0.9 0.04],'Parent',hFigure1);
    hTFPlot           = getPlotHandles(2,1,[0.05 0.1 0.3 0.67],0.01,0.08,0);
    hsubplotDE        = getPlotHandles(1,2,[0.46 0.1 0.53 0.63],0.05,0.01,0);
    
    hFreqVsTime                 = hTFPlot(1);
    hPowervsTime                = hTFPlot(2);
    hRawAlphaPowerVsTrials      = hsubplotDE(1);
    hChInAlphaPowerVsTime       = hsubplotDE(2);
    
    set(hChInAlphaPowerVsTime, 'Box', 'off');
%     hChInAlphaPowerVsTrialtypes = axes('Position', [0.8 0.5 0.15 0.2]); % position for  within the figure 2
    hChInAlphaPowerVsTrialtypes = axes('Position', [0.86 0.65 0.13 0.15]);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%% Subplot 1 (hExperimentFlow) %%%%%%%%%%%%%%%%%%%%
    
    dX = 1; dY = 1;
    colorNameTypes = 'rgb';
    % Load saved data
    trialTypeFileName = fullfile(folderName,[subjectName 'trialTypeList.mat']);
    load(trialTypeFileName,'trialTypeList');
    % input: trialtype list:
    trialTypeList1D = trialTypeList';
    trialTypeList1D = trialTypeList1D(:);
    
    hold(hExperimentFlow,'on');    % plotting the experimental plot using patch
    
    for i = 1:3
        pos         = find(trialTypeList1D == i);
        patchX      = pos';
        patchLocX   = [patchX; patchX; patchX+dX; patchX+dX];
        patchY      = zeros(size(patchX));
        patchLocY   = [patchY; patchY+dY; patchY+dY; patchY];
        patch(patchLocX,patchLocY,colorNameTypes(i),'parent',hExperimentFlow,'EdgeColor','k');
    end
    
    xlim(hExperimentFlow,[1,61]);  ylim(hExperimentFlow,[-2,2]);  xlabel(hExperimentFlow,'Trial No','FontSize',12,'FontWeight','bold','Color','k');
    set(hExperimentFlow,'Ytick',[]);
    set(hExperimentFlow,'Ycolor',[1 1 1]);  % Making yaxis invisible
    hExperimentFlow_xTickVal = linspace(0,60,6)+1;
    set(hExperimentFlow,'Xtick',hExperimentFlow_xTickVal);
    set(hExperimentFlow,'xticklabels',{'0','12','24','36','48','60'});
    
    text(0.06,-0.6,'First Session','Color','k','fontsize',fontSizeVal,'fontweight','bold','unit','normalized','parent',hExperimentFlow);
    text(0.06+0.2,-0.6,'Second Session','Color','k','fontsize',fontSizeVal,'fontweight','bold','unit','normalized','parent',hExperimentFlow);
    text(0.06+0.4,-0.6,'Third Session','Color','k','fontsize',fontSizeVal,'fontweight','bold','unit','normalized','parent',hExperimentFlow);
    text(0.06+0.6,-0.6,'Fourth Session','Color','k','fontsize',fontSizeVal,'fontweight','bold','unit','normalized','parent',hExperimentFlow);
    text(0.06+0.8,-0.6,'Fifth Session','Color','k','fontsize',fontSizeVal,'fontweight','bold','unit','normalized','parent',hExperimentFlow);
    Xlabel_pos = get(get(hExperimentFlow, 'XLabel'), 'Position');
    set(get(hExperimentFlow, 'XLabel'), 'Position', Xlabel_pos + [0 -1 0]);
    hold(hExperimentFlow,'off');
    
%     hExperimentFlow.YAxis.Visible = 'off';  % Alternative way
%   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%% Subplot 1.b(2) (hFreqVsTime) %%%%%%%%%%%%%%%%%%%%
    
    % spectogram plot
    % we need frequency, power and time. 
%%%     SessionNumber   = input('Input the Session Number, Default value 2 \n');
    if ~exist('SessionNumber','var'),  SessionNumber   = 2;     end    
%%%     trialNumber     = input('Input the trial Number, Default value 13 \n'); % change accordingly
    if ~exist('trialNumber','var'),    trialNumber     = 4;     end
    
    calibrationData     = load(fullfile(folderName,[subjectName 'CalibrationProcessedData' 'Session' num2str(SessionNumber) '.mat']));
    analysisData        = load(fullfile(folderName,[subjectName 'ProcessedData' 'Session' num2str(SessionNumber) 'Trial' num2str(trialNumber) '.mat']));
    
    tfDataTMP           = log10(analysisData.tfData);
    
%%% change this if have to use only alpha power from the data matrix:
%     meanCalibrationPower    = log10(mean(calibrationData.tfData,2)); % taking log of mean
    meanCalibrationPower     = mean(log10(calibrationData.tfData),2); % taking mean of log
    freqVsTimevsDeltaPower   = 10*(tfDataTMP - repmat(meanCalibrationPower,1,size(tfDataTMP,2)));
    
    freqVals    = analysisData.freqVals;    
    timeValsTF  = analysisData.timeValsTF ;
    stFreqList  = analysisData.stFreqList(6:end);
    
    %%%%% 2nd plot 
    pcolor(hFreqVsTime,timeValsTF(6:end),freqVals,freqVsTimevsDeltaPower(:,6:end));  shading(hFreqVsTime,'interp'); % timevasl on row; freqval on column
    colormap(hFreqVsTime,'jet'); cBar = colorbar(hFreqVsTime,'northoutside');

%     set(hFreqVsTime,'fontsize',fontsize,'fontweight','bold');
    ylabel(hFreqVsTime,'Frequency (Hz)','fontsize',fontSizeVal,'fontweight','bold');
    xlabel(hFreqVsTime,'Time (s)','fontsize',fontSizeVal,'fontweight','bold');
%     title(hFreqVsTime,'Delta spectogram','fontsize',fontsize,'fontweight','bold'); 

%     set(cBar,'fontsize',fontsize,'fontweight','bold');
    xlabel(cBar,'dB','fontsize',fontSizeVal,'fontweight','bold');
    ylabel(cBar,'\DeltaPower(dB)','fontsize',fontSizeVal,'fontweight','bold');

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%% Subplot 1.c(3) (hPowervsTime) %%%%%%%%%%%%%%%%%%%
        
    deltaPowerVsTime = mean(freqVsTimevsDeltaPower,1); 
    axes(hPowervsTime);
    yyaxis(gca,'left');
    plot(gca,timeValsTF(6:end),deltaPowerVsTime(6:end));
%     set(hPowervsTime,'fontsize',fontsize,'fontweight','bold');
    ylabel(gca,'Change In Power (dB)','fontsize',fontSizeVal,'fontweight','bold');
    xlabel(gca,'Time (s)','fontsize',fontSizeVal,'fontweight','bold');
    
    yyaxis(gca,'right');
    plot(gca,timeValsTF(6:end),stFreqList);
    ylabel(gca,'Tone Frequency (Hz)','fontsize',fontSizeVal,'fontweight','bold');
    xlim(gca,[5 50]);
    hold(gca,'off');
%%%     title(hPowervsTime,'','fontsize',fontsize,'fontweight','bold'); 
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%% Subplot 1.d(4) (hRawAlphaPowerVsTrials) %%%%%%%%%
     
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%% Subplot 1.e(5) (hChInAlphaPowerVsTime) %%%%%%%%%%
          
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%% Subplot 1.e.2(6) (hChInAlphaPowerVsTrialtypes) %%%%%%%%%%
    
    analysisPlotHandles.powerVsTrial    = hRawAlphaPowerVsTrials;
    analysisPlotHandles.powerVsTime     = hChInAlphaPowerVsTime; 
    analysisPlotHandles.barPlot         = hChInAlphaPowerVsTrialtypes;
    
    [analysisPlotHandles,~,~,~,~,~,~,~,typeNameList]  = biofeedbackAnalysis_Ver2_Mod_fig1(subjectName,'',1,analysisPlotHandles);
%     
%     [analysisPlotHandles,colorNames,meanEyeOpenPowerList(i,:), ...
%     meanEyeClosedPowerList(i,:),calibrationPowerList(i,:), ...
%     trialTypeList1D(i,:),powerVsTimeList(i,:,:),timeVals,typeNameList] ...
%         = biofeedbackAnalysis_Ver2(subjectNames{i},'',1,[]);
    
    %% Providing the legends and axis names:
    
    % legend([h1 h2 h3],'','','','Location','Best')
    set(analysisPlotHandles.barPlot,'XTick',1:3,'XTickLabel',typeNameList);
    xlabel(analysisPlotHandles.powerVsTrial,'TrialNo','fontsize',fontSizeVal,'fontweight','bold');
    ylabel(analysisPlotHandles.powerVsTrial,'Raw Alpha Power (log(AlphaPower))','fontsize',fontSizeVal,'fontweight','bold');
%     xlabel(analysisPlotHandles.diffPowerVsTrial,'TrialNo');
%     ylabel(analysisPlotHandles.diffPowerVsTrial,'\DeltaPower(dB)');
%     title(['Subject',num2str(i)]);
    % legend([h1 h2 h3],'','','','Location','Best')
%     title(analysisPlotHandles.powerVsTime,['Subject',num2str(i)]);
    xlim(analysisPlotHandles.powerVsTime,[5 51]);
    xlabel(analysisPlotHandles.powerVsTime,'Time(sec)','fontsize',fontSizeVal,'fontweight','bold');
    ylabel(analysisPlotHandles.powerVsTime,'\Delta Alpha Power (dB)','fontsize',fontSizeVal,'fontweight','bold');
    xlabel(analysisPlotHandles.barPlot,'TrialTypes','fontsize',fontSizeVal,'fontweight','bold');
    ylabel(analysisPlotHandles.barPlot,'\Delta Alpha Power (dB)','fontsize',fontSizeVal,'fontweight','bold');   
    
    title(hExperimentFlow,['Subject: ', subjectName]);
    disp('one subject data analysis completed');
    
    
    % Changing axis properties of the figures:
    set(findobj(gcf,'type','axes'),'box','off'...
    ,'fontsize',fontSizeVal...
    ,'FontWeight','Bold'...
    ,'TickDir','out'...
    ,'TickLength',[0.02 0.02]...
    ,'linewidth',1.2...
    ,'xcolor',[0 0 0]...
    ,'ycolor',[0 0 0]...
    );

    % Resetting first axis:
    set(hExperimentFlow,'Ytick',[]);
    set(hExperimentFlow,'Ycolor',[1 1 1]);  % Making yaxis invisible

    set(findall(gcf, 'Type', 'Line'),'LineWidth',2);
    set(findall(gcf, 'Type', 'errorbar'),'LineWidth',1.2);
  
    
 
end