
hf  = figure(5);
ha1 = subplot(121);
ha2 = subplot(122);
fontSizeVal         = 12;
set(hf,'color','w');
% input parameters for the demo:
Fsound          = 50000;
Fc              = 1000;
Fi              = 500;


% h = getPlotHandles_old(1,2);

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

% hSubjectScreen              = getPlotHandles(1,1,[0.3  0.8  0.4  0.1],0.1,0,0);
hTFPlot                     = getPlotHandles(1,2,[0.08 0.15 0.85 0.5],0.1,0,0);
hsubjectHandle              = subplot('Position',[0.05 0.7 0.9 0.04],'Parent',hf);
hFreqVsTime                 = hTFPlot(1);
hPowervsTime                = hTFPlot(2);
set(hsubjectHandle,'Ytick',[]);
set(hsubjectHandle,'Ycolor',[1 1 1]);  % Making yaxis invisible
set(hsubjectHandle,'Xtick',[]);
set(hsubjectHandle,'Xcolor',[1 1 1])


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
timeValsTF  = timeValsTF+0.5;
stFreqList  = analysisData.stFreqList(6:end);

Alpha_meanCalibrationPower = mean(log10(mean(calibrationData.tfData(calibrationData.alphaPos,calibrationData.timePosCalibration),1)));
Alpha_deltaPowerVsTimeTMP = 10*(Alpha_tfDataTMP - repmat(Alpha_meanCalibrationPower,1,50));

timeStartS = 5;
epochsToAvg = 5;
BoxCar_Alpha_deltaPowerVsTimeTMP = Alpha_deltaPowerVsTimeTMP;
for i = 6:50
    BoxCar_Alpha_deltaPowerVsTimeTMP(i) = mean(Alpha_deltaPowerVsTimeTMP((timeStartS-epochsToAvg+1):timeStartS));
    timeStartS = timeStartS+1;
end

hold(hFreqVsTime,'on');
j =1;

for i=2:50
    
    %-------------------plot first graph
    
    if i == 2
         text(hsubjectHandle,0.35,1.1,'Please keep your eyes open','Units','Normalized','fontsize',30,'fontweight','bold');
    elseif i==16
%         hold(hsubjectHandle,'on');
        cla(hsubjectHandle)
        text(hsubjectHandle,0.35,1.1,'Close your eyes and relax','Units','Normalized','fontsize',30,'fontweight','bold');
%         drawnow
%         hold(hsubjectHandle,'off');
    elseif i==50
%         hold(hsubjectHandle,'on');
        cla(hsubjectHandle)
        text(hsubjectHandle ,0.2,1.1,'Mean Change in Alpha Power is 7.43 dB ','Units','Normalized','fontsize',30,'fontweight','bold');
%         drawnow
%         hold(hsubjectHandle,'off');
    end
    timeValsTF_temp                         = timeValsTF(1:i);
    freqVsTimevsDeltaPower_temp             = freqVsTimevsDeltaPower(:,1:i);
    Alpha_deltaPowerVsTimeTMP_temp          = Alpha_deltaPowerVsTimeTMP(1:i);
    
    
    pcolor(hFreqVsTime,timeValsTF_temp((end-1):end),freqVals,freqVsTimevsDeltaPower_temp(:,(end-1):end));
    shading(hFreqVsTime, 'interp'); % timevasl on row; freqval on column
    colormap(hFreqVsTime,'jet'); cBar = colorbar(hFreqVsTime,'northoutside');
    ylabel(hFreqVsTime,  'Frequency (Hz)',     'fontsize',fontSizeVal,'fontweight','bold');
    xlabel(hFreqVsTime,  'Time (s)',           'fontsize',fontSizeVal,'fontweight','bold');
    xlabel(cBar,         'dB',                 'fontsize',fontSizeVal,'fontweight','bold');
    ylabel(cBar,         'Change in Power(dB)','fontsize',fontSizeVal,'fontweight','bold');
    set(hFreqVsTime,'xticklabelmode','manual','xtick',[1 10:10:40 50],'xticklabel',[1 10:10:40 50],'xlim',[1 50],'ylim',[0 30],'linewidth',4);
    set(hFreqVsTime,'fontsize',fontSizeVal,'fontweight','bold');
    % Adding reference line
    x = 1:50;
    y1 = ones(1,50)*8;
    y2 = ones(1,50)*13;
    plot(hFreqVsTime,x,y1,'--k','LineWidth',2.5);
    plot(hFreqVsTime,x,y2,'--k','LineWidth',2.5);
    set(hFreqVsTime,'linewidth',2.5);
    
    %
    if i<6
        plot(hPowervsTime,timeValsTF_temp,Alpha_deltaPowerVsTimeTMP_temp,'linewidth',2,'Color',[0.5430 0 0]);
        xlim(hPowervsTime,[1 50]);
        ylim(hPowervsTime,[-5 15]);
%         set(hPowervsTime,'linewidth',2,'Color',[0.5430 0 0]);
        ylabel(hPowervsTime,'Change in Alpha Power (dB)');
        set(hPowervsTime,'fontsize',fontSizeVal,'fontweight','bold');
        set(hPowervsTime,'linewidth',2.5);
    end
    % Sound from 6th second:
    
    if i>5
        timeValsTF_temp_2 = timeValsTF(6:i);
        stFreq =  stFreqList(j);
        BoxCar_Alpha_deltaPowerVsTimeTMP_temp   = BoxCar_Alpha_deltaPowerVsTimeTMP(1:j);
        stFreqList_temp                         = stFreqList(1:j);
        sampleDurationS = 1;
        soundTone = sin(2*pi*stFreq*(0:1/Fsound:sampleDurationS-1/Fsound));
        sound(soundTone,Fsound);
        
        %----------------------------------------------------------------------------
%         plot(hPowervsTime,timeValsTF_temp_2,BoxCar_Alpha_deltaPowerVsTimeTMP_temp,'--','LineWidth',2,'Color',[1.0000,0.2695,0]);
%         ylabel(hPowervsTime,'Change in Alpha Power (dB)','fontsize',fontSizeVal,'fontweight','bold');
        [hAx_hPowervsTime,hAlpha_deltaPowerVsTimeTMP,hstFreqList] = plotyy(hPowervsTime,timeValsTF_temp,Alpha_deltaPowerVsTimeTMP_temp,timeValsTF_temp_2,stFreqList_temp);
        ylabel(hAx_hPowervsTime(2),'Tone Frequency (Hz)')
        set(hAx_hPowervsTime(2),'fontsize',fontSizeVal,'fontweight','bold');
        set(hAlpha_deltaPowerVsTimeTMP,'linewidth',2,'Color',[0.5430 0 0]);
        set(hAx_hPowervsTime(1),'YColor',[0.5430 0 0]);
        set(hAx_hPowervsTime(1),'Ylim',[-5 15]);
        set(hAx_hPowervsTime(1),'yticklabelmode','manual','ytick',[-5 0 5 10 15],'yticklabel',[-5 0 5 10 15]);
        ylabel(hAx_hPowervsTime(1),'Change in Alpha Power (dB)');
        set(hAx_hPowervsTime(1),'fontsize',fontSizeVal,'fontweight','bold');
        set(hstFreqList,'linewidth',2,'Color',[0.1328 0.5430 0.1328]);
        set(hAx_hPowervsTime(2),'YColor',[0.1328 0.5430 0.1328]);
        set(hAx_hPowervsTime(2),'Xlim',[1 50]);
        set(hAx_hPowervsTime(2),'Ylim',[0 8000]);
        set(hAx_hPowervsTime(2),'yticklabelmode','manual','ytick',[0 2000:2000:6000 8000],'yticklabel',[0 2000:2000:6000 8000]);
        % set(hAx_hPowervsTime(2),'XLim',[5 50]);
        set(hPowervsTime,'xticklabelmode','manual','xtick',[1 10:10:40 50],'xticklabel',[1 10:10:40 50],'xlim',[1 50]);
        %     set(hPowervsTime,'XLim',[5 50]);
        %     yyaxis(gca,'right');
        %     plot(gca,timeValsTF(6:end),stFreqList);
        %     ylabel(gca,'Tone Frequency (Hz)','fontsize',fontSizeVal,'fontweight','bold');
%         xlim(hPowervsTime,[1 50]);
        %      legend({'Smoothed Alpha Power','Alpha Power','Frequency'},'Orientation','vertical','Box','off','FontSize',8,'Units','Normalized','Position',[0.001,0.33,0.2,0.05]);
%         legend({'Smoothed Alpha Power','Alpha Power','Frequency'},'Orientation','vertical','Box','off','FontSize',8,'Units','Normalized','Location','southeast');
        xlabel(hPowervsTime,'Time (s)','fontsize',fontSizeVal,'fontweight','bold');
        j =j+1;
    end
    
    %---------------------getting frame and pausing for half a second
    %     F(i) = getframe(gca);
    pause(0.8);
    %     timeValsTF_temp = [];
    %     freqVsTimevsDeltaPower_temp =[];
end
%%%%% 2nd plot
% pcolor(hFreqVsTime,timeValsTF(1:end),freqVals,freqVsTimevsDeltaPower(:,1:end));  shading(hFreqVsTime,'interp'); % timevasl on row; freqval on column
% colormap(hFreqVsTime,'jet'); cBar = colorbar(hFreqVsTime,'northoutside');
% set(hFreqVsTime,'xticklabelmode','manual','xtick',[1 10:10:40 50],'xticklabel',[1 10:10:40 50],'xlim',[5 50],'linewidth',4);

%     set(hFreqVsTime,'xlim',[5 50]);
%     set(hFreqVsTime,'fontsize',fontsize,'fontweight','bold');
% ylabel(hFreqVsTime,'Frequency (Hz)','fontsize',fontSizeVal,'fontweight','bold');
% hold(hFreqVsTime,'on');
%     xlabel(hFreqVsTime,'Time (s)','fontsize',fontSizeVal,'fontweight','bold');
%     title(hFreqVsTime,'Delta spectogram','fontsize',fontsize,'fontweight','bold');

%     set(cBar,'fontsize',fontsize,'fontweight','bold');
% xlabel(cBar,'dB','fontsize',fontSizeVal,'fontweight','bold');
% ylabel(cBar,'\DeltaPower(dB)','fontsize',fontSizeVal,'fontweight','bold');


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

%-------------------------------------------------------------------------------

hold(hPowervsTime,'off');
%%%     title(hPowervsTime,'','fontsize',fontsize,'fontweight','bold');



