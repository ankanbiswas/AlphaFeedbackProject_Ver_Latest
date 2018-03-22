% Slope analysis of deltapowerVsTime for all the 24 subjects
% SLope analysyed for time 20 to 40 seconds of the experiment duration

function slopeAnalysis_deltaSlopeVsSlopeInvalid_v2(hdeltaSlopeVsSlopeInvalid,fontsize)
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
    sl_AnalysisRange = 21:50;
    x_axis           = 1:length(sl_AnalysisRange);
    % doen this already previously
    
    % Refurnashing the data for suiting to our purpose:
    % done this already previously
    
    % Initializing variables:
    %     numTrials         =  3;
    %     sl_ValidTrials    =  [];
    %     sl_InvalidTrials  =  [];
    AllSubPower_ValidTrials = [];
    AllSubPower_InvalidTrials = [];
    AllSub_sl_ConstantTrials =  [];
    
    % First step is to calculate slope for all the subjects, all the trialtypes
    
    % slope analysis for valid trilas, all subject:
    %     for i = 1: numSubjects
    %         subNum = i;
    %         temp_dataSlAnalysis  = EX_mean_deltaPowerVsTimeList_valid(subNum,:);
    %         temp_sl_coefficients = polyfit(x_axis,temp_dataSlAnalysis,1);
    %         temp_Slope = temp_sl_coefficients(1);
    %         sl_ValidTrials = [sl_ValidTrials;temp_Slope];
    %     end
    for i = 1: numSubjects
        subNum = i;
        meanAlphaPowerValid  = EX_mean_deltaPowerVsTimeList_valid(subNum,:);
        %         temp_sl_coefficients = polyfit(x_axis,temp_dataSlAnalysis,1);
        temp_SubPower_ValidTrials = mean(meanAlphaPowerValid);
        AllSubPower_ValidTrials = [AllSubPower_ValidTrials;temp_SubPower_ValidTrials];
    end
    % slope analysis for Invalid trilas, all subject:
    %     for i = 1: numSubjects
    %         subNum = i;
    %         temp_dataSlAnalysis  = EX_mean_deltaPowerVsTimeList_invalid(subNum,:);
    %         temp_sl_coefficients = polyfit(x_axis,temp_dataSlAnalysis,1);
    %         temp_Slope           = temp_sl_coefficients(1);
    %         sl_InvalidTrials     = [sl_InvalidTrials;temp_Slope];
    %     end
    for i = 1: numSubjects
        subNum = i;
        meanAlphaPowerInValid  = EX_mean_deltaPowerVsTimeList_invalid(subNum,:);
        %         temp_sl_coefficients = polyfit(x_axis,temp_dataSlAnalysis,1);
        temp_SubPower_InvalidTrials   = mean(meanAlphaPowerInValid);
        AllSubPower_InvalidTrials     = [AllSubPower_InvalidTrials;temp_SubPower_InvalidTrials];
    end
    
    % slope analysis for constant trilas, all subject:
    for i = 1: numSubjects
        subNum = i;
        meanAlphaPowerValid  = EX_mean_deltaPowerVsTimeList_constant(subNum,:);
        temp_sl_coefficients = polyfit(x_axis,meanAlphaPowerValid,1);
        temp_Slope           = temp_sl_coefficients(1);
        AllSub_sl_ConstantTrials    = [AllSub_sl_ConstantTrials;temp_Slope];
    end
    
    % finding delta slope
    
    %     deltaSl_valid_M_invalid = sl_ValidTrials - sl_InvalidTrials;
    AllSubdeltaPower_valid_M_invalid = AllSubPower_ValidTrials - AllSubPower_InvalidTrials;
    
    % plot the data, finally
    hold(hdeltaSlopeVsSlopeInvalid,'on');
    grid(hdeltaSlopeVsSlopeInvalid,'on');
    
%     scatterColor = flipud(jet(length(AllSubPower_InvalidTrials)));
    dotSize = 60;
    slopeMatrix = [AllSub_sl_ConstantTrials,AllSubdeltaPower_valid_M_invalid];
    [~,idx] = sort(slopeMatrix(:,1));
    slopeMatrixSorted = slopeMatrix(idx,:);
    
    for i = 1:length(slopeMatrixSorted)
        if (slopeMatrixSorted(i,1) < 0) && (slopeMatrixSorted(i,2) > 0)
            scatter(hdeltaSlopeVsSlopeInvalid,slopeMatrixSorted(i,1),slopeMatrixSorted(i,2),dotSize,'^','k','filled');
        else
            scatter(hdeltaSlopeVsSlopeInvalid,slopeMatrixSorted(i,1),slopeMatrixSorted(i,2),dotSize,'o','k','filled');            
        end
        hold(hdeltaSlopeVsSlopeInvalid,'on');
    end
%     legend(hdeltaSlopeVsSlopeInvalid,'slope');
    xlabel(hdeltaSlopeVsSlopeInvalid,'Constant Slope','fontsize',fontsize,'fontweight','bold');
    ylabel(hdeltaSlopeVsSlopeInvalid,'\delta (Valid - Invalid) Power','fontsize',fontsize,'fontweight','bold');
    
    x=linspace(-0.3,0.2,50) ;
    y=linspace(0,0,50) ;
    %     x2 = linspace(,0,50);
    x2 = linspace(-1,3.5,50);
    plot(hdeltaSlopeVsSlopeInvalid,x,y,'k--') ;
    plot(hdeltaSlopeVsSlopeInvalid,y,x2,'k--') ;
    %     xlim(hdeltaSlopeVsSlopeInvalid,[-0.3 0.2]);
    %     ylim(hdeltaSlopeVsSlopeInvalid,[-0.1 0.2]);
    
    hold(hdeltaSlopeVsSlopeInvalid,'off');
    
end
