% Slope analysis of deltapowerVsTime for all the 24 subjects
% SLope analysyed for time 20 to 40 seconds of the experiment duration

function slopeAnalysis_deltaSlopeVsSlopeInvalid(hdeltaSlopeVsSlopeInvalid,fontsize)
% Initialization steps.
% clc;        % Clear the command window
% close all;  % Close all figures 
% clear;      % Erase all existing variables

% Load data 
load('EX_mean_deltaPowerVsTimeList_trialtypes.mat');

% Getting size of the data matrices
% [~, numConsTrials,~]                        = size(deltaPowerVsTimeList_constant);
% [~, numInvalidTrials, ~]                    = size(deltaPowerVsTimeList_invalid);
% [numSubjects, numValidTrials, totTimeS]     = size(deltaPowerVsTimeList_valid);
% [numSubjects, totTimeS] = size(EX_mean_deltaPowerVsTimeList_constant);
[numSubjects, ~] = size(EX_mean_deltaPowerVsTimeList_constant);

% Define slope analysis range:
sl_AnalysisRange = 20:40;
x_axis           = 1:length(sl_AnalysisRange);
% doen this already previously

% Refurnashing the data for suiting to our purpose:
% done this already previously

% Initializing variables:
numTrials         =  3;
sl_ValidTrials    =  [];
sl_InvalidTrials  =  [];
sl_ConstantTrials =  [];

% First step is to calculate slope for all the subjects, all the trialtypes

% slope analysis for valid trilas, all subject:
for i = 1: numSubjects
    subNum = i;
    temp_dataSlAnalysis  = EX_mean_deltaPowerVsTimeList_valid(subNum,:);
    temp_sl_coefficients = polyfit(x_axis,temp_dataSlAnalysis,1);
    temp_Slope = temp_sl_coefficients(1);
    sl_ValidTrials = [sl_ValidTrials;temp_Slope];
end

% slope analysis for Invalid trilas, all subject:
for i = 1: numSubjects
    subNum = i;
    temp_dataSlAnalysis  = EX_mean_deltaPowerVsTimeList_invalid(subNum,:);
    temp_sl_coefficients = polyfit(x_axis,temp_dataSlAnalysis,1);
    temp_Slope = temp_sl_coefficients(1);
    sl_InvalidTrials = [sl_InvalidTrials;temp_Slope];
end
% slope analysis for constant trilas, all subject:
for i = 1: numSubjects
    subNum = i;
    temp_dataSlAnalysis  = EX_mean_deltaPowerVsTimeList_constant(subNum,:);
    temp_sl_coefficients = polyfit(x_axis,temp_dataSlAnalysis,1);
    temp_Slope = temp_sl_coefficients(1);
    sl_ConstantTrials = [sl_ConstantTrials;temp_Slope];
end

% finding delta slope

deltaSl_valid_M_invalid = sl_ValidTrials - sl_InvalidTrials;

% plot the data, finally
hold(hdeltaSlopeVsSlopeInvalid,'on');
grid(hdeltaSlopeVsSlopeInvalid,'on');
x=linspace(-0.03,0.05) ;
y=linspace(0,0) ;
plot(hdeltaSlopeVsSlopeInvalid,x,y,'k-') ;
plot(hdeltaSlopeVsSlopeInvalid,y,x,'k-') ;
 
scatter(hdeltaSlopeVsSlopeInvalid,sl_InvalidTrials,deltaSl_valid_M_invalid,[],[0 0 1],'filled');
legend(hdeltaSlopeVsSlopeInvalid,'slope');
xlabel(hdeltaSlopeVsSlopeInvalid,'Invalid','fontsize',fontsize,'fontweight','bold'); 
ylabel(hdeltaSlopeVsSlopeInvalid,'\delta (Valid - Invalid)','fontsize',fontsize,'fontweight','bold');
hold(hdeltaSlopeVsSlopeInvalid,'off');

end
