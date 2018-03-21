% biofeedbackFigure4(subjectName,folderName)
% Main aim of the code is to plot
%          1. meanDeltaPowerVsTime 
%          2. deltaPowerVsSlope
% In immediete future aim is to develop it further to include the slope

% total no of trials = 60 (5*12)
% Duration of trial  = 50 sec

% trialtypes: Valid: 1, Invalid: 2, Constant: 3;

fontsize = 14;

hfig4 = figure(5);
hdeltaSlopeVsSlopeInvalid = axes('parent',hfig4,'unit','normalized','Position',[0.17 0.15 0.68 0.8]);
% hdeltaSlopeVsSlopeInvalid = subplot(1,1,1,'parent',hfig4);
% hAverageDeltaPowerVsTime  = subplot(1,2,1);
% hdeltaSlopeVsSlopeInvalid = subplot(1,2,2);

startTrialTimePos = 13; % default one

% averageDeltaPowerVsTime(startTrialTimePos,hAverageDeltaPowerVsTime,fontsize);
% slopeAnalysis_deltaSlopeVsSlopeInvalid(hdeltaSlopeVsSlopeInvalid,fontsize);
slopeAnalysis_deltaSlopeVsSlopeInvalid_v2(hdeltaSlopeVsSlopeInvalid,fontsize);

%--------------------------------------------------------------------------
% Set axis properties
hplot = hdeltaSlopeVsSlopeInvalid;
subplot(hplot);
set(hplot,'box','off'...
    ,'fontsize',fontsize...
    ,'TickDir','out'...
    ,'TickLength',[0.03 0.03]...
    ,'linewidth',1.2...
    ,'xcolor',[0 0 0]...
    ,'ycolor',[0 0 0]...
    );

% hplot = hAverageDeltaPowerVsTime;
% subplot(hplot);
% set(hplot,'box','off'...
%     ,'fontsize',fontsize...
%     ,'TickDir','out'...
%     ,'TickLength',[0.03 0.03]...
%     ,'linewidth',1.2...
%     ,'xcolor',[0 0 0]...
%     ,'ycolor',[0 0 0]...
%     );



