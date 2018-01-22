
function checkplot_time_2(handles,timeToPlot,datatoplot,freq,powertoplot,combRawPower)

     hf1 = handles.hRawTrace;
%      hf2 = handles.hRawTrace_2;
     hf3 = handles.hTF;
     hf4 = handles.hPSD(1,1);
     hf5 = handles.hPSD(1,2);
     
    calibrationDurationS = handles.calibrationDurationS ;
    runtimeDurationS  = handles.runtimeDurationS;
    totalTime = calibrationDurationS + runtimeDurationS;
%     blData = BL.blData;
%     blPower = BL.blPower;
    
    % The idea is in the first count concatenate the bldata and the first
    % second of the data
    
%     if (EXPcount == 1)
%       % concatenate the bldata and the first
%       % second of the data
%       Fs = 500;
%       
      
    datatoplot_1 = mean(datatoplot,1);
    datatoplot = mean(datatoplot,1);
    plot(hf1,timeToPlot,datatoplot_1,'k');
%     plot(hf2,timeToPlot,datatoplot,'k');
    xlim(hf1,[0 totalTime]);
%     xlim(hf2,[(timeToPlot(end)-5.998) (timeToPlot(end)+ 0.0020)]);     
    hold(hf1,'on');

    axes(hf3);
    hold(hf3,'on');
    if size(powertoplot)>1        
        pcolor(1:size(powertoplot,2), freq, powertoplot);
%         colorbar(hf3);
        colormap jet; shading interp;
        caxis(hf3,[-2 2]);
        xlim(hf3,[1 totalTime]); 
        x = 1:totalTime;
        y1 = ones(1,totalTime)*8;
        y2 = ones(1,totalTime)*13;
    end
       plot(x,y1,'--k');
       plot(x,y2,'--k');
       title('Time Frequency Plot')
       xlabel(hf3, 'Time (s)'); ylabel(hf3, 'Frequency');
       
       
    axes(hf4); % plotting rawpds
    % plot the baseline and plot the raw in every second  
    blPowerToplot           = mean(combRawPower(:,1:calibrationDurationS),2);
%     plot(hf4,freq',blPowerToplot,'color',[0.7 0.7 0.7]);  
    if size(combRawPower,2)<totalTime
        plot(hf4,freq',blPowerToplot,'g',freq',combRawPower(:,end),'k');
    else
        plot(hf4,freq',blPowerToplot,'g',freq',mean(combRawPower((calibrationDurationS+1):end),2),'k');
    end
    xlim(hf4,[0 30]); ylim(hf4,[0 20]);
    xlabel(hf4, 'Frequency (Hz)');
    ylabel(hf4, 'Change in Pow');
    
       
    axes(hf5); % plotting psd  
    if size(powertoplot,2)<totalTime  
        plot(hf5,freq',powertoplot(:,end), 'color',[0.7 0.7 0.7]); 
    else
        plot(hf5,freq',mean(powertoplot((calibrationDurationS+1):end),2),'k','linewidth',2);
    end
    xlabel(hf5, 'Frequency (Hz)');
    ylabel(hf5, 'Change in Pow');
    xlim(hf5,[0 30]);  
   
    drawnow;
      
end