% biofeedbackFigure4(subjectName,folderName)
% Main aim of the code is to plot
%          1. meanDeltaPowerVsTime 
%          2. deltaPowerVsSlope
% In immediete future aim is to develop it further to include the slope

% total no of trials = 60 (5*12)
% Duration of trial  = 50 sec

% trialtypes: Valid: 1, Invalid: 2, Constant: 3;

fontsize = 10;

hfig4 = figure(4);
hAverageDeltaPowerVsTime  = subplot(1,2,1);
hdeltaSlopeVsSlopeInvalid = subplot(1,2,2);

startTrialTimePos = 13; % default one

averageDeltaPowerVsTime(startTrialTimePos,hAverageDeltaPowerVsTime,fontsize);
slopeAnalysis_deltaSlopeVsSlopeInvalid(hdeltaSlopeVsSlopeInvalid,fontsize);