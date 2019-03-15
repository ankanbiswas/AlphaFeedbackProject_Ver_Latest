% Please comment out 85 to 99 for Matlab version 2015b or earlier

function biofeedbackFigure1_only_b(subjectName,folderName)
    
    % Function to generate figure1
    % Input:
        % Subject name as string
        % foldername (optional)
        
    % Generating figure and defining font properties:
    randomfigurenumber  = 100+randi(100); 
    figure(randomfigurenumber);
    fontSizeVal         = 10;
    hFigure1            = gcf;
    %     set(gcf,'Visible', 'off'); 
    
    %---------------------------------------------------------------
    % Defining parameters for extracting out data:
%     subjectName     = 'PB';
    SessionNumber   = 2;
    trialNumber     = 4;
    
    if ~exist('subjectName',    'var');      subjectName       = 'PB';         end
    if ~exist('folderName',     'var');      folderName        = '';           end
    if ~exist('SessionNumber',  'var'),      SessionNumber     = 2;            end  
    if ~exist('trialNumber',    'var'),      trialNumber       = 4;            end
            
    if isempty(folderName)
        pathStr     = fileparts(pwd);
        folderName  = fullfile(pathStr,'Data',subjectName);
    end
       
    hExperimentFlow   = subplot('Position',[0.05 0.9 0.9 0.04],'Parent',hFigure1);
    hTFPlot           = getPlotHandles(2,1,[0.05 0.1 0.3 0.67],0.01,0.04,0);
    hsubplotDE        = getPlotHandles(1,2,[0.46 0.1 0.53 0.63],0.05,0.01,0);
    
    %%%% ------------------------------------------ %%%%
    
    hfigure_2 = figure(2);
    haxfigure_2 = axes('parent',hfigure_2);
    hfigure_2.PaperType = 'a4';
    hfigure_2.PaperUnits = 'centimeters';
    hfigure_2.PaperSize = [18.3 24.7/2];
    hfigure_2.PaperOrientation = 'Portrait';
    hfigure_2.PaperPosition = [0 0 hfigure_2.PaperSize];
    hfigure_2.Color = [1 1 1];
    
    hTFPlot(2)
    hFreqVsTime                 = hTFPlot(1);
    hPowervsTime                = haxfigure_2;
    hRawAlphaPowerVsTrials      = hsubplotDE(1);
    hChInAlphaPowerVsTime       = hsubplotDE(2);
    
    set(hChInAlphaPowerVsTime, 'Box', 'off');
%     hChInAlphaPowerVsTrialtypes = axes('Position', [0.8 0.5 0.15 0.2]); % position for  within the figure 2
%     hChInAlphaPowerVsTrialtypes = axes('Position', [0.86 0.65 0.13 0.15]);
    
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
    
%     hValidText      = getPlotHandles(1,1,[0.76 0.95 0.04 0.02]);
%     rectangle(gca,'Position',[0 0 0.1 0.1],'FaceColor','r','EdgeColor','r',...
%         'LineWidth',1); axis(gca,'equal'); set(gca,'Visible','off');
%     text(gca,0.84,0.65,'Valid','Units','Normalized','fontsize',fontSizeVal,'fontweight','bold');
%     text(gca,-2.5,0.6,'Trial Types:','Units','Normalized','fontsize',fontSizeVal+2,'fontweight','bold');
%     hInValidText    = getPlotHandles(1,1,[0.82 0.95 0.04 0.02]);
%     rectangle(gca,'Position',[0 0 0.1 0.1],'FaceColor','g','EdgeColor','g',...
%         'LineWidth',1); axis(gca,'equal'); set(gca,'Visible','off');
%     text(gca,0.84,0.74,'Invalid','Units','Normalized','fontsize',fontSizeVal,'fontweight','bold');
%     hConstantText   = getPlotHandles(1,1,[0.88 0.95 0.04 0.02]);
%     rectangle(gca,'Position',[0 0 0.1 0.1],'FaceColor','b','EdgeColor','b',...
%         'LineWidth',1); axis(gca,'equal'); set(gca,'Visible','off');
%     text(gca,0.84,0.74,'Constant','Units','Normalized','fontsize',fontSizeVal,'fontweight','bold');
    
%     hExperimentFlow.YAxis.Visible = 'off';  % Alternative way

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%% Subplot 1.b(2) (hFreqVsTime) %%%%%%%%%%%%%%%%%%%%
    % spectogram plot
%%%     SessionNumber   = input('Input the Session Number, Default value 2 \n');
     
%%%     trialNumber     = input('Input the trial Number, Default value 13 \n'); % change accordingly
       
    calibrationData     = load(fullfile(folderName,[subjectName 'CalibrationProcessedData' 'Session' num2str(SessionNumber) '.mat']));
    analysisData        = load(fullfile(folderName,[subjectName 'ProcessedData' 'Session' num2str(SessionNumber) 'Trial' num2str(trialNumber) '.mat']));
    
    tfDataTMP           = log10(analysisData.tfData);
    Alpha_tfDataTMP     = log10(mean(analysisData.tfData(analysisData.alphaPos,:),1));
    
%%% change this if have to use only alpha power from the data matrix:
%     meanCalibrationPower    = log10(mean(calibrationData.tfData,2)); % taking log of mean
    meanCalibrationPower     = mean(log10(calibrationData.tfData),2); % taking mean of log
    freqVsTimevsDeltaPower   = 10*(tfDataTMP - repmat(meanCalibrationPower,1,size(tfDataTMP,2)));
           
    freqVals    = analysisData.freqVals;    
    timeValsTF  = analysisData.timeValsTF ;
    stFreqList  = analysisData.stFreqList(6:end);
    
    %%%%% 2nd plot 
    pcolor(hFreqVsTime,timeValsTF(5:end),freqVals,freqVsTimevsDeltaPower(:,5:end));  shading(hFreqVsTime,'interp'); % timevasl on row; freqval on column
    colormap(hFreqVsTime,'jet'); cBar = colorbar(hFreqVsTime,'northoutside');
    set(hFreqVsTime,'xticklabelmode','manual','xtick',[5.5 10:5:45 49.5],'xticklabel',[5 10:5:45 50],'xlim',[5.5 49.5],'linewidth',4);

%     set(hFreqVsTime,'xlim',[5 50]);
%     set(hFreqVsTime,'fontsize',fontsize,'fontweight','bold');
    ylabel(hFreqVsTime,'Frequency (Hz)','fontsize',fontSizeVal,'fontweight','bold');
    xlabel(hFreqVsTime,'Time(sec)','fontsize',fontSizeVal,'fontweight','bold');
    hold(hFreqVsTime,'on');
%     xlabel(hFreqVsTime,'Time (s)','fontsize',fontSizeVal,'fontweight','bold');
%     title(hFreqVsTime,'Delta spectogram','fontsize',fontsize,'fontweight','bold'); 

%     set(cBar,'fontsize',fontsize,'fontweight','bold');
    xlabel(cBar,'dB','fontsize',fontSizeVal,'fontweight','bold');
    ylabel(cBar,'\DeltaPower(dB)','fontsize',fontSizeVal,'fontweight','bold');

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%% Subplot 1.c(3) (hPowervsTime) %%%%%%%%%%%%%%%%%%%
   
    deltaPowerVsTime = mean(freqVsTimevsDeltaPower,1); 
%     axes(hPowervsTime);
%     yyaxis(gca,'left');
%     plot(hPowervsTime,timeValsTF(6:end),deltaPowerVsTime(6:end),'linewidth',2);
% %     set(hPowervsTime,'fontsize',fontsize,'fontweight','bold');
%     ylabel(hPowervsTime,'Change In Power (dB)','fontsize',fontSizeVal,'fontweight','bold');
%     xlabel(hPowervsTime,'Time (s)','fontsize',fontSizeVal,'fontweight','bold');
    hold(hPowervsTime,'on');
    %-------------------------------------------------------------------------------
     Alpha_meanCalibrationPower = mean(log10(mean(calibrationData.tfData(calibrationData.alphaPos,calibrationData.timePosCalibration),1)));
     Alpha_deltaPowerVsTimeTMP = 10*(Alpha_tfDataTMP - repmat(Alpha_meanCalibrationPower,1,50));
     timeStartS = 5;
     epochsToAvg = 5;
     BoxCar_Alpha_deltaPowerVsTimeTMP = Alpha_deltaPowerVsTimeTMP;
     for i = 6:50
         BoxCar_Alpha_deltaPowerVsTimeTMP(i) = mean(Alpha_deltaPowerVsTimeTMP((timeStartS-epochsToAvg+1):timeStartS));
         timeStartS = timeStartS+1;
     end
     %-------------------------------------------------------------------------------
     plot(hPowervsTime,timeValsTF(6:end),BoxCar_Alpha_deltaPowerVsTimeTMP(6:end),'--','LineWidth',2,'Color',[1.0000,0.2695,0]);
     ylabel(hPowervsTime,'Change In Power (dB)','fontsize',fontSizeVal,'fontweight','bold');
     [hAx_hPowervsTime,hAlpha_deltaPowerVsTimeTMP,hstFreqList] = plotyy(hPowervsTime,timeValsTF(6:end),Alpha_deltaPowerVsTimeTMP(6:end),timeValsTF(6:end),stFreqList);
     ylabel(hAx_hPowervsTime(2),'Tone Frequency (Hz)')
     set(hAx_hPowervsTime(2),'fontsize',fontSizeVal,'fontweight','bold'); 
     set(hAlpha_deltaPowerVsTimeTMP,'linewidth',2,'Color',[0.5430 0 0]);
     set(hAx_hPowervsTime(1),'YColor',[0.5430 0 0]);
     set(hstFreqList,'linewidth',2,'Color',[0.1328 0.5430 0.1328]);
     set(hAx_hPowervsTime(2),'YColor',[0.1328 0.5430 0.1328]);
     set(hAx_hPowervsTime(2),'XLim',[5 50]);
     set(hPowervsTime,'xticklabelmode','manual','xtick',[6 10:5:45 49.5],'xticklabel',[6 10:5:45 50],'xlim',[6 49.5]);
%      set(hPowervsTime,'XLim',[5 50]);
%     yyaxis(gca,'right');
%     plot(gca,timeValsTF(6:end),stFreqList);
%     ylabel(gca,'Tone Frequency (Hz)','fontsize',fontSizeVal,'fontweight','bold');
%      xlim(hPowervsTime,[5 50]);
%      legend({'Smoothed Alpha Power','Alpha Power','Frequency'},'Orientation','vertical','Box','off','FontSize',8,'Units','Normalized','Position',[0.001,0.33,0.2,0.05]);
     legend({'Smoothed Alpha Power','Alpha Power','Frequency'},'Orientation','vertical','Box','off','FontSize',8,'Units','Normalized','Location','southeast');
     xlabel(hPowervsTime,'Time (s)','fontsize',fontSizeVal,'fontweight','bold');
     hold(hPowervsTime,'off');
%%%     title(hPowervsTime,'','fontsize',fontsize,'fontweight','bold'); 
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%% Subplot 1.d(4) (hRawAlphaPowerVsTrials) %%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%  Subplot 1.e(5) (hChInAlphaPowerVsTime) %%%%%%%%%% 
    %%%%%%%%%%%%%%%%%%%%% Subplot 1.e.2(6) (hChInAlphaPowerVsTrialtypes) %%
    
    analysisPlotHandles.powerVsTrial    = hRawAlphaPowerVsTrials;
    analysisPlotHandles.powerVsTime     = hChInAlphaPowerVsTime; 
%     analysisPlotHandles.barPlot         = hChInAlphaPowerVsTrialtypes;
    
    [analysisPlotHandles,~,~,~,~,~,~,~,~]  = biofeedbackAnalysis_Ver2_Mod_fig1(subjectName,'',1,analysisPlotHandles);
%     
%     [analysisPlotHandles,colorNames,meanEyeOpenPowerList(i,:), ...
%     meanEyeClosedPowerList(i,:),calibrationPowerList(i,:), ...
%     trialTypeList1D(i,:),powerVsTimeList(i,:,:),timeVals,typeNameList] ...
%         = biofeedbackAnalysis_Ver2(subjectNames{i},'',1,[]);
    
    %---------------------------------------------------------------
    % Providing the legends and axis names:
    
    % legend([h1 h2 h3],'','','','Location','Best')
%     set(analysisPlotHandles.barPlot,'XTick',1:3,'XTickLabel',typeNameList);
    xlim(analysisPlotHandles.powerVsTrial,[-1 61]);
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
%     legend(analysisPlotHandles.powerVsTime,{'RawPower','Alpha Power','Frequency'},'Orientation','vertical','Location','Best','Box','off','FontSize',8,'Units','Normalized');
    
%     xlabel(analysisPlotHandles.barPlot,'TrialTypes','fontsize',fontSizeVal,'fontweight','bold');
%     ylabel(analysisPlotHandles.barPlot,'\Delta Alpha Power (dB)','fontsize',fontSizeVal,'fontweight','bold');   
    
    %---------------------------------------------------------------
    % Changing the figure and axes properties to make it nicer:
    
    title(hExperimentFlow,['Subject: ', subjectName]);
    disp('one subject data analysis completed');
       
    % Changing axis properties of the figures:
    set(findobj(gcf,'type','axes'),'box','off'...
    ,'fontsize',fontSizeVal...
    ,'FontWeight','Bold'...
    ,'TickDir','out'...
    ,'TickLength',[0.02 0.02]...
    ,'linewidth',1.5 ...
    );
%     ,'xcolor',[0 0 0]...
%     ,'ycolor',[0 0 0]...
    % Resetting first axis:
    set(hExperimentFlow,'Ytick',[]);
    set(hExperimentFlow,'Ycolor',[1 1 1]);  % Making yaxis invisible
    % Changin the linewidth:
%     set(findall(analysisPlotHandles.powerVsTime, 'Type', 'Line'),'LineWidth',2);
    set(findall(gcf, 'Type', 'errorbar'),'LineWidth',1.2);   
    set(hFreqVsTime,'linewidth',2.5);
    
    %-------------------------------$$$New addition: panel number %-------
    text(-0.042,0.95,'A','Units','Normalized','fontsize',fontSizeVal+5,'fontweight','bold','Parent',hExperimentFlow);
    text(-0.13,1.25,'B','Units','Normalized','fontsize',fontSizeVal+5,'fontweight','bold','Parent',hFreqVsTime );
    text(-0.13,1,'C','Units','Normalized','fontsize',fontSizeVal+5,'fontweight','bold','Parent',hPowervsTime );
    text(-0.15,1,'D','Units','Normalized','fontsize',fontSizeVal+5,'fontweight','bold','Parent',analysisPlotHandles.powerVsTrial );
    text(-0.15,1,'E','Units','Normalized','fontsize',fontSizeVal+5,'fontweight','bold','Parent',analysisPlotHandles.powerVsTime );
    x = 1:50;
    y1 = ones(1,50)*8;
    y2 = ones(1,50)*13;    
    plot(hFreqVsTime,x,y1,'--k','LineWidth',2.5);
    plot(hFreqVsTime,x,y2,'--k','LineWidth',2.5);
    
       
end