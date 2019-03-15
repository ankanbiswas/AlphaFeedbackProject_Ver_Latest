 % Slope analysis of deltapowerVsTime for all the 24 subjects
% SLope analysyed for time 20 to 40 seconds of the experiment duration
% Go to line no: 165 for figure 5

function slopeAnalysis_deltaSlopeVsSlopeInvalid_v3(hdeltaSlopeVsSlopeInvalid,hFSVsDeltaPowerVsTime,hRSVSDeltaPowerVsTime,hDSVSDeltaPowerVsTime,fontsize)
    
    % Initialization steps.
    % clc;        % Clear the command window
    % close all;  % Close all figures
    % clear;      % Erase all existing variables
    
    % Load data
    load('EX_mean_deltaPowerVsTimeList_trialtypes.mat');
    %     FS = [4,8,7,5,8,3,9,10,10,7,10,8,10,10,9,10,9,9,9,9,10,10,8];
    % with only 23 subjects removing one outlier
%     RS = [8,8,8,8,5,7,9,7, 8, 8,8, 8,8, 9, 8,8, 8,7,7, 8,10,9, 7];
%     DS = [2,5,3,5,2,5,1,1, 1, 9,1, 8,1, 1, 1,4, 1,5,2, 6,1, 1, 1];
%     FS = [4,8,7,5,8,3,9,10,10,7,10,8,10,10,9,10,9,9,9, 9,10,10,8]; 
    % with all the 24 subjects
    RS = [8,8,8,8,5,7,9,7, 8, 8,8, 8,8, 9, 8,8, 8,7,7,10,8,10,9, 7];
    DS = [2,5,3,5,2,5,1,1, 1, 9,1, 8,1, 1, 1,4, 1,5,2,1, 6,1, 1, 1];
    FS = [4,8,7,5,8,3,9,10,10,7,10,8,10,10,9,10,9,9,9,1, 9,10,10,8];
    
    
    FS = FS';
    RS = RS';
    DS = DS';
    % Getting size of the data matrices
    % [~, numConsTrials,~]                        = size(deltaPowerVsTimeList_constant);
    % [~, numInvalidTrials, ~]                    = size(deltaPowerVsTimeList_invalid);
    % [numSubjects, numValidTrials, totTimeS]     = size(deltaPowerVsTimeList_valid);
    % [numSubjects, totTimeS] = size(EX_mean_deltaPowerVsTimeList_constant);
    [numSubjects, ~] = size(EX_mean_deltaPowerVsTimeList_constant);
    
    % Define slope analysis range:
    sl_AnalysisRange = 21:50;
    x_axis = sl_AnalysisRange;
    %     x_axis           = 1:length(sl_AnalysisRange);
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
    %%Addition: ------ on 27th august
    AllSub_sl_InvalidTrials =  [];
    AllSub_sl_ValidTrials =  [];
    
    STD_AllSubPower_ValidTrials = [];
    STD_AllSubPower_InvalidTrials = [];
    SEM_AllSubdeltaPower_valid_M_invalid = [];
    
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
        temp_SubPower_ValidTrials      = mean(meanAlphaPowerValid);
        STD_temp_SubPower_ValidTrials  = std(meanAlphaPowerValid);
        AllSubPower_ValidTrials        = [AllSubPower_ValidTrials;temp_SubPower_ValidTrials];
        STD_AllSubPower_ValidTrials    = [STD_AllSubPower_ValidTrials;STD_temp_SubPower_ValidTrials];
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
        temp_SubPower_InvalidTrials       = mean(meanAlphaPowerInValid);
        STD_temp_SubPower_InvalidTrials   = std(meanAlphaPowerInValid);
        AllSubPower_InvalidTrials         = [AllSubPower_InvalidTrials;temp_SubPower_InvalidTrials];
        STD_AllSubPower_InvalidTrials     = [STD_AllSubPower_InvalidTrials;STD_temp_SubPower_InvalidTrials];
    end
    
    % slope analysis for constant trilas, all subject:
    for i = 1: numSubjects
        subNum = i;
        meanAlphaPowerConstant  = EX_mean_deltaPowerVsTimeList_constant(subNum,:);
        lm = fitlm(x_axis,meanAlphaPowerConstant,'linear') ;
        %         temp_sl_coefficients = polyfit(x_axis,meanAlphaPowerConstant,1);
        temp_Slope           = lm.Coefficients{2,1};
        AllSub_sl_ConstantTrials    = [AllSub_sl_ConstantTrials;temp_Slope];
    end
    
    %----------------------Addition---------on 27th august
     for i = 1: numSubjects
        subNum = i;
        meanAlphaPowerConstant  = EX_mean_deltaPowerVsTimeList_invalid(subNum,:);
        lm = fitlm(x_axis,meanAlphaPowerConstant,'linear') ;
        %         temp_sl_coefficients = polyfit(x_axis,meanAlphaPowerConstant,1);
        temp_Slope           = lm.Coefficients{2,1};
        AllSub_sl_InvalidTrials    = [AllSub_sl_InvalidTrials;temp_Slope];
     end
    
      for i = 1: numSubjects
        subNum = i;
        meanAlphaPowerConstant  = EX_mean_deltaPowerVsTimeList_valid(subNum,:);
        lm = fitlm(x_axis,meanAlphaPowerConstant,'linear') ;
        %         temp_sl_coefficients = polyfit(x_axis,meanAlphaPowerConstant,1);
        temp_Slope               = lm.Coefficients{2,1};
        AllSub_sl_ValidTrials    = [AllSub_sl_ValidTrials;temp_Slope];
      end
    
    %----------------------Addition till this---------on 27th august
    
    % finding delta slope
    
    %     deltaSl_valid_M_invalid = sl_ValidTrials - sl_InvalidTrials;
    AllSubdeltaPower_valid_M_invalid = AllSubPower_ValidTrials - AllSubPower_InvalidTrials;
    for i = 1:numSubjects
        SEM_temp_SubPower_InvalidTrials          =  sqrt((STD_AllSubPower_ValidTrials(i,1)^2)/30 + (STD_AllSubPower_InvalidTrials(i,1)^2)/30);
        SEM_AllSubdeltaPower_valid_M_invalid     = [SEM_AllSubdeltaPower_valid_M_invalid;SEM_temp_SubPower_InvalidTrials];
    end
    
    % plot the data, finally
    hold(hdeltaSlopeVsSlopeInvalid,'on');
    %     grid(hdeltaSlopeVsSlopeInvalid,'on');
    
    %     scatterColor = flipud(jet(length(AllSubPower_InvalidTrials)));
    dotSize = 12;
    slopeMatrix = [AllSub_sl_ConstantTrials,AllSubdeltaPower_valid_M_invalid];
    %     [~,idx] = sort(slopeMatrix(:,1));
    %     slopeMatrixSorted = slopeMatrix(idx,:);
    
    %############################################################
    %----------------------
    %% change here for only 23 subjects removing one outlier
    %-----------------------
   
    slopeMatrix(20, :) = [];
    
    for i = 1:length(slopeMatrix)
        %         if (slopeMatrixSorted(i,1) < 0) && (slopeMatrixSorted(i,2) > 0)
        if i<7
            %             scatter(hdeltaSlopeVsSlopeInvalid,slopeMatrix(i,1),slopeMatrix(i,2),dotSize,'^','k','filled');
            %             scatter(slopeMatrix(i,1), slopeMatrix(i,2),80,'k^','filled');
            %             plot([slopeMatrix(i,1); slopeMatrix(i,1)], [slopeMatrix(i,2)-SEM_AllSubdeltaPower_valid_M_invalid(i,1); slopeMatrix(i,2)+SEM_AllSubdeltaPower_valid_M_invalid(i,1)], 'k','MarkerSize' ,0.8);
            h_sig_sub_bonCorr = errorbar(hdeltaSlopeVsSlopeInvalid,slopeMatrix(i,1),slopeMatrix(i,2),SEM_AllSubdeltaPower_valid_M_invalid(i,1),'^k','LineWidth',0.8,'MarkerSize',10,'MarkerFaceColor','k');
        elseif i>6 && i<12
            h_sig_sub = errorbar(hdeltaSlopeVsSlopeInvalid,slopeMatrix(i,1),slopeMatrix(i,2),SEM_AllSubdeltaPower_valid_M_invalid(i,1),'^k','LineWidth',0.8,'MarkerSize',10,'MarkerFaceColor',[0.6 0.6 0.6]);
        else
            %             scatter(hdeltaSlopeVsSlopeInvalid,slopeMatrix(i,1),slopeMatrix(i,2),dotSize,'o','k','filled');
            %             scatter(slopeMatrix(i,1), slopeMatrix(i,2),80,'ko','filled');
            %             plot([slopeMatrix(i,1); slopeMatrix(i,1)], [slopeMatrix(i,2)-SEM_AllSubdeltaPower_valid_M_invalid(i,1); slopeMatrix(i,2)+SEM_AllSubdeltaPower_valid_M_invalid(i,1)], 'k','MarkerSize' ,0.8);
            h_Nonsig_sub = errorbar(hdeltaSlopeVsSlopeInvalid,slopeMatrix(i,1),slopeMatrix(i,2),SEM_AllSubdeltaPower_valid_M_invalid(i,1),'ok','LineWidth',0.8,'MarkerSize',10,'MarkerFaceColor','w');
            %
        end
    end
    %     legend(hdeltaSlopeVsSlopeInvalid,'slope');
    legend([h_sig_sub_bonCorr h_sig_sub h_Nonsig_sub],{'Significant after bonferroni correction','Significant before Bonferroni Correction','Non significant'},'Location','north','Orientation','horizontal');
    % Adding regression line:
    
    x = AllSub_sl_ConstantTrials;
    x (20, :) = [];
    slopeMatrix(20, :) = [];
    X = [ones(size(x)) x];
    y = AllSubdeltaPower_valid_M_invalid;
    y (20, :) = [];
    lm = fitlm(x,y,'linear');
    [b,~,~,~,stats] = regress(y,X,0.01);
    % b = regress(y,X);
    xfit = min(x):0.01:max(x);
    YFIT = lm.Coefficients{1,1} + lm.Coefficients{2,1}*xfit;
    p_val_slope = lm.Coefficients{2,4};
    %     p_value_regress = stats(1);
    %     r_value_regress = stats(3);
    
    plot(hdeltaSlopeVsSlopeInvalid,xfit,YFIT,'color','k','linewidth',4);
    
    pval_pow = ceil(log10(p_val_slope))-1;
    pval_ini = p_val_slope*10^abs(pval_pow);
    text(0.75,0.81,['p = ' num2str(pval_ini,'%.2f') 'x' '10^{' num2str(pval_pow) '}'],'color','k','fontsize',fontsize,'fontweight','bold','unit','normalized','parent',hdeltaSlopeVsSlopeInvalid);
      
%     text(0.75,0.81,['p < 10^{' num2str(ceil(log10(p_val_slope))) '}'],'Color','k','fontsize',fontsize,'fontweight','bold','unit','normalized','parent',hdeltaSlopeVsSlopeInvalid);
    %     text(0.75,0.85,['\beta_{1} = ' num2str(lm.Coefficients{2,1},'%.3f')],'Color','k','fontsize',fontsize,'fontweight','bold','unit','normalized','parent',hdeltaSlopeVsSlopeInvalid);
    text(0.75,0.85,['Slope = ' num2str(lm.Coefficients{2,1},'%.3f')],'Color','k','fontsize',fontsize,'fontweight','bold','unit','normalized','parent',hdeltaSlopeVsSlopeInvalid);
    xlabel(hdeltaSlopeVsSlopeInvalid,'Mean slope of constant trials','fontsize',fontsize,'fontweight','bold');
    ylabel(hdeltaSlopeVsSlopeInvalid,'\delta (Valid - Invalid) power','fontsize',fontsize,'fontweight','bold');
    
    x=linspace(-0.3,0.2,50) ;
    y=linspace(0,0,50) ;
    %     x2 = linspace(,0,50);
    x2 = linspace(-1,4.5,50);
    plot(hdeltaSlopeVsSlopeInvalid,x,y,'k--') ;
    plot(hdeltaSlopeVsSlopeInvalid,y,x2,'k--') ;
    xlim(hdeltaSlopeVsSlopeInvalid,[-0.3 0.15]);
    ylim(hdeltaSlopeVsSlopeInvalid,[-1 5]);
    hold(hdeltaSlopeVsSlopeInvalid,'off');
    
    %--------------------------------------------------------------------------------
    %%%%%%%%%%%%%%%%%%%%%%%%%%^^^^^^^^^^^^^^Fig 5^^^^^^^^^^^^^^^^%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %---------------------------------------------------------------------------
    hold(hFSVsDeltaPowerVsTime,'on');
    
    for i = 1:length(slopeMatrix)
        if i<7
            errorbar(hFSVsDeltaPowerVsTime,FS(i,1),AllSubdeltaPower_valid_M_invalid(i,1),SEM_AllSubdeltaPower_valid_M_invalid(i,1),'^k','LineWidth',0.8,'MarkerSize',10,'MarkerFaceColor','k');
        elseif i>6 && i<12
            errorbar(hFSVsDeltaPowerVsTime,FS(i,1),AllSubdeltaPower_valid_M_invalid(i,1),SEM_AllSubdeltaPower_valid_M_invalid(i,1),'^k','LineWidth',0.8,'MarkerSize',10,'MarkerFaceColor',[0.6 0.6 0.6]);
        else
            errorbar(hFSVsDeltaPowerVsTime,FS(i,1),AllSubdeltaPower_valid_M_invalid(i,1),SEM_AllSubdeltaPower_valid_M_invalid(i,1),'ok','LineWidth',0.8,'MarkerSize',10,'MarkerFaceColor','w');
        end
    end
    
    % Adding regression line:
    
    x = FS;
    X = [ones(size(x)) x];
    y = AllSubdeltaPower_valid_M_invalid;
    y (20, :) = [];
    lm = fitlm(x,y,'linear');
    [b,~,~,~,stats] = regress(y,X,0.01);
     p_value_regress = stats(3);
     slope_value_regress = b(2);
    % b = regress(y,X);
    xfit = min(x):0.01:max(x);
    YFIT = lm.Coefficients{1,1} + lm.Coefficients{2,1}*xfit;
    p_val_slope = lm.Coefficients{2,4};
    ylim(hFSVsDeltaPowerVsTime,[-1 5]);
    plot(hFSVsDeltaPowerVsTime,xfit,YFIT,'color','k','linewidth',4);
    text(0.15,0.81,['p = ' num2str( p_value_regress,'%.3f')],'Color','k','fontsize',fontsize,'fontweight','bold','unit','normalized','parent',hFSVsDeltaPowerVsTime);
    %     text(0.15,0.81,['p < 10^{' num2str(ceil(log10(p_val_slope))) '}'],'Color','k','fontsize',fontsize,'fontweight','bold','unit','normalized','parent',hFSVsDeltaPowerVsTime);
    %     text(0.15,0.85,['\beta_{1} = ' num2str(lm.Coefficients{2,1},'%.3f')],'Color','k','fontsize',fontsize,'fontweight','bold','unit','normalized','parent',hFsVsDeltaPowerVsTime);
    text(0.15,0.85,['Slope = ' num2str(slope_value_regress,'%.3f')],'Color','k','fontsize',fontsize,'fontweight','bold','unit','normalized','parent',hFSVsDeltaPowerVsTime);
    
    %-----------------------------------------------------------
    xlim(hFSVsDeltaPowerVsTime,[-1 11]);
    %     set(hAx_hPowervsTime(2),'XLim',[5 50]);
    set(hFSVsDeltaPowerVsTime,'xticklabelmode','manual','xtick',[1 10]);
    set(hFSVsDeltaPowerVsTime,'xticklabels',{'Ignored','Attended'});
    xlabel(hFSVsDeltaPowerVsTime,'Attention score (AS)','fontsize',fontsize,'fontweight','bold');
    ylabel(hFSVsDeltaPowerVsTime,'\delta (Valid - Invalid) power','fontsize',fontsize,'fontweight','bold');
    
    hold(hFSVsDeltaPowerVsTime,'off');
    
    %----------------------------------------------------------------------------
    hold(hRSVSDeltaPowerVsTime,'on');
    for i = 1:length(slopeMatrix)
        if i<7
            errorbar(hRSVSDeltaPowerVsTime,RS(i,1),AllSubdeltaPower_valid_M_invalid(i,1),SEM_AllSubdeltaPower_valid_M_invalid(i,1),'^k','LineWidth',0.8,'MarkerSize',10,'MarkerFaceColor','k');
        elseif i>6 && i<12
            errorbar(hRSVSDeltaPowerVsTime,RS(i,1),AllSubdeltaPower_valid_M_invalid(i,1),SEM_AllSubdeltaPower_valid_M_invalid(i,1),'^k','LineWidth',0.8,'MarkerSize',10,'MarkerFaceColor',[0.6 0.6 0.6]);
        else
            errorbar(hRSVSDeltaPowerVsTime,RS(i,1),AllSubdeltaPower_valid_M_invalid(i,1),SEM_AllSubdeltaPower_valid_M_invalid(i,1),'ok','LineWidth',0.8,'MarkerSize',10,'MarkerFaceColor','w');
        end
    end
    
    % Adding regression line:
    
    x = RS;
    X = [ones(size(x)) x];
    y = AllSubdeltaPower_valid_M_invalid;
    lm = fitlm(x,y,'linear');
%     [b,~,~,~,stats] = regress(y,X,0.01);   %%% Have removed this line to
%     fix bug as on 27th august, 2018. 

    % b = regress(y,X);
    xfit = min(x):0.01:max(x);
    YFIT = lm.Coefficients{1,1} + lm.Coefficients{2,1}*xfit;
    p_val_slope = lm.Coefficients{2,4};
    ylim(hRSVSDeltaPowerVsTime,[-1 5]);
    plot(hRSVSDeltaPowerVsTime,xfit,YFIT,'color','k','linewidth',4);
    text(0.15,0.81,['p = ' num2str(p_val_slope,'%.3f')],'Color','k','fontsize',fontsize,'fontweight','bold','unit','normalized','parent',hRSVSDeltaPowerVsTime);
    text(0.15,0.85,['Slope = ' num2str(lm.Coefficients{2,1},'%.3f')],'Color','k','fontsize',fontsize,'fontweight','bold','unit','normalized','parent',hRSVSDeltaPowerVsTime);
    
    %-----------------------------------------
    xlim(hRSVSDeltaPowerVsTime,[-1 11]);
    %     set(hAx_hPowervsTime(2),'XLim',[5 50]);
    set(hRSVSDeltaPowerVsTime,'xticklabelmode','manual','xtick',[1 10]);
    set(hRSVSDeltaPowerVsTime,'xticklabels',{'Not relaxing','Very relaxing'});
    xlabel(hRSVSDeltaPowerVsTime,'Relaxation score (RS)','fontsize',fontsize,'fontweight','bold');
    %     ylabel(hRSVSDeltaPowerVsTime,'\delta (Valid - Invalid) Power','fontsize',fontsize,'fontweight','bold');
    hold(hRSVSDeltaPowerVsTime,'off');
    
    %----------------------------------------------------------------------------------
    
    hold(hDSVSDeltaPowerVsTime,'on');
    for i = 1:length(slopeMatrix)
        if i<7
            errorbar(hDSVSDeltaPowerVsTime,DS(i,1),AllSubdeltaPower_valid_M_invalid(i,1),SEM_AllSubdeltaPower_valid_M_invalid(i,1),'^k','LineWidth',0.8,'MarkerSize',10,'MarkerFaceColor','k');
        elseif i>6 && i<12
            errorbar(hDSVSDeltaPowerVsTime,DS(i,1),AllSubdeltaPower_valid_M_invalid(i,1),SEM_AllSubdeltaPower_valid_M_invalid(i,1),'^k','LineWidth',0.8,'MarkerSize',10,'MarkerFaceColor',[0.6 0.6 0.6]);
        else
            errorbar(hDSVSDeltaPowerVsTime,DS(i,1),AllSubdeltaPower_valid_M_invalid(i,1),SEM_AllSubdeltaPower_valid_M_invalid(i,1),'ok','LineWidth',0.8,'MarkerSize',10,'MarkerFaceColor','w');
        end
    end
    
    % Adding regression line:
    
    x = DS;
    X = [ones(size(x)) x];
    y = AllSubdeltaPower_valid_M_invalid;
    lm = fitlm(x,y,'linear');
    [b,~,~,~,stats] = regress(y,X,0.01);
    p_value_regress = stats(3);
    slope_value_regress = b(2);
    % b = regress(y,X);
    xfit = min(x):0.01:max(x);
    YFIT = lm.Coefficients{1,1} + lm.Coefficients{2,1}*xfit;
    p_val_slope = lm.Coefficients{2,4};
    ylim(hDSVSDeltaPowerVsTime,[-1 5]);
    plot(hDSVSDeltaPowerVsTime,xfit,YFIT,'color','k','linewidth',4);
    text(0.7,0.81,['p = ' num2str(p_value_regress,'%.3f')],'Color','k','fontsize',fontsize,'fontweight','bold','unit','normalized','parent',hDSVSDeltaPowerVsTime);
    text(0.7,0.85,['Slope = ' num2str(slope_value_regress,'%.3f')],'Color','k','fontsize',fontsize,'fontweight','bold','unit','normalized','parent',hDSVSDeltaPowerVsTime);
    
    %-------------------------------------
    xlim(hDSVSDeltaPowerVsTime,[-1 11]);
    %     set(hAx_hPowervsTime(2),'XLim',[5 50]);
    set(hDSVSDeltaPowerVsTime,'xticklabelmode','manual','xtick',[1 10]);
    set(hDSVSDeltaPowerVsTime,'xticklabels',{'Not disturbing','Very disturbing'});
    xlabel(hDSVSDeltaPowerVsTime,'Disturbance score (DS)','fontsize',fontsize,'fontweight','bold');
    %     ylabel(hDSVSDeltaPowerVsTime,'\delta (Valid - Invalid) Power','fontsize',fontsize,'fontweight','bold');
    hold(hDSVSDeltaPowerVsTime,'off');
    
    %------------------------------------------------------------------------------------
%     save('SubjectiveScores.mat','FS','RS','DS','AllSubdeltaPower_valid_M_invalid','AllSub_sl_ConstantTrials');
end
