
% Analysis script two
% For plotting change in alpha power with time
% Avarage across all the time

function [] = change_alphapower_trials(handles,subdata)
% 
    tot_trials              = handles.tot_trials;
    h_changeAlphaTrials     = handles.changeAlphaTrial ;
    h_ConsChAlpTrials       = handles.ConsChAlpTrials; 
    h_DepChAlpTrials        = handles.DepChAlpTrials;
    h_IndChAlpTrials        = handles.IndChAlpTrials;
    h_SessionSummary        = handles.SessionSummary;
    
    calibrationDurationS    = handles.calibrationDurationS ;
    runtimeDurationS        = handles.runtimeDurationS ;
    totTimeToPlot           = calibrationDurationS + runtimeDurationS ;
    
    
    totalTrialno            = size(subdata,2);
    TrialsAlphaPow          = [];
    trials                  = 1:totalTrialno ;

    for i = 1:totalTrialno
        meanAlphaPow = mean(subdata{6,i},2);
        TrialsAlphaPow = [TrialsAlphaPow meanAlphaPow];
    end

    AllTrialsMeanAlphaPow = 10*mean(TrialsAlphaPow,1);   error_all = (std(TrialsAlphaPow)/sqrt(size(TrialsAlphaPow,1)));
   
    plot(h_changeAlphaTrials,trials,AllTrialsMeanAlphaPow,'-o'); 
    xlim(h_changeAlphaTrials,[0 tot_trials]);
    xlabel(h_changeAlphaTrials,'Trials','FontSize',10,'FontWeight','bold','Color','k'); 
    ylabel(h_changeAlphaTrials,'Ch Alpha Pow (db)','FontSize',10,'FontWeight','bold','Color','k');
     
    % Saving the current axes as a new figure
%     fig3 = figure('visible','off');
%     newax = copyobj(h_changeAlphaTrials, fig3);
%     set(newax, 'units', 'normalized', 'position', [0.13 0.11 0.775 0.815]);
%     print(fig3,'Average alpha power vs. trials','-dpng');
%     hgsave(fig3,'Average alpha power vs. trials')    % save it
% 
%     close(fig3)                                    % clean up by closing it
  
    %% Subdividing the plot into trialtypes

     trialType      = [subdata{2,1:end}];
     ind_Cons       = find(trialType==0);
     ind_alphaDep   = find(trialType==1);
     ind_alphaInd   = find(trialType==2);
     
     constrailno = 1:size(ind_Cons,2);
     deptrailano = 1:size(ind_alphaDep,2);
     indtraialno = 1:size(ind_alphaInd,2);
    
     % Creating consdata matrix
    if size(ind_Cons,2) >= 1
        for i = 1:size(ind_Cons,2)
            rowval              = ind_Cons(i);
            alpConsPowData(:,i)  = mean(subdata{6,rowval});
        end
        avgtime_alpConsPowData      = 10*mean(alpConsPowData(calibrationDurationS+1:totTimeToPlot,:),1);
        AllTrails_alpConsPowData    = mean(avgtime_alpConsPowData); stderr_AllTrails_alpConsPowData = std(avgtime_alpConsPowData)/sqrt(size(avgtime_alpConsPowData,2));
        if size(ind_Cons,2) == 1
            stderr_alpaConsData     = (std(alpConsPowData))/sqrt(size(TrialsAlphaPow,1));
            stderr_alpaConsData     = repmat(stderr_alpaConsData,1,size(avgtime_alpConsPowData,2));
        else
            stderr_alpaConsData     = (std(alpConsPowData))/sqrt(size(TrialsAlphaPow,1));
        end
        plot(h_ConsChAlpTrials,constrailno,avgtime_alpConsPowData,'b-*'); hold(h_ConsChAlpTrials,'on') 
        hc =  errorbar(h_ConsChAlpTrials,constrailno,avgtime_alpConsPowData,stderr_alpaConsData,stderr_alpaConsData,'.','MarkerSize',5,...
        'MarkerEdgeColor','b','MarkerFaceColor','b');
        set(hc,'color','b');
        % set(gca,'XTickLabel',{'1','2','3','4'});
        title(h_ConsChAlpTrials,'Contant feedback','FontSize',10,'FontWeight','bold','Color','k');
        xlabel(h_ConsChAlpTrials,'TrialNumber','FontSize',8,'FontWeight','bold','Color','k'); 
        ylabel(h_ConsChAlpTrials,'Ch Alpha Pow (db)  ','FontSize',8,'FontWeight','bold','Color','k');
        hold(h_ConsChAlpTrials,'off') 
    end

    % Creating Alpha dependent matrix
    
    if size(ind_alphaDep,2) >= 1
        for i = 1:size(ind_alphaDep,2)
            rowval              = ind_alphaDep(i);
            alpDepPowData(:,i)  = mean(subdata{6,rowval});
%             mean(subdata{6,rowval}(:,6:11),2);
        end
        avgtime_alpDepPowData   = 10*mean(alpDepPowData(calibrationDurationS+1:totTimeToPlot,:),1);  
        AllTrails_alpDepPowData = mean(avgtime_alpDepPowData); stderr_AllTrails_alpDepPowData = std(avgtime_alpDepPowData)/sqrt(size(avgtime_alpDepPowData,2));
        if size(ind_alphaDep,2) == 1
            stderr_alpaDepData  = (std(alpDepPowData))/sqrt(size(TrialsAlphaPow,1));
            stderr_alpaDepData  = repmat(stderr_alpaDepData,1,size(avgtime_alpDepPowData,2));
        else
            stderr_alpaDepData  = (std(alpDepPowData))/sqrt(size(TrialsAlphaPow,1));
        end
        plot(h_DepChAlpTrials,deptrailano,avgtime_alpDepPowData,'m-*'); hold(h_DepChAlpTrials,'on') 
        hc =  errorbar(h_DepChAlpTrials,deptrailano,avgtime_alpDepPowData,stderr_alpaDepData,stderr_alpaDepData,'.','MarkerSize',5,...
        'MarkerEdgeColor','m','MarkerFaceColor','m');
        set(hc,'color','m');
        
        % set(gca,'XTickLabel',{'1','2','3','4'});
        title(h_DepChAlpTrials,'Dependent feedback','FontSize',10,'FontWeight','bold','Color','k');
        xlabel(h_DepChAlpTrials,'TrialNumber','FontSize',8,'FontWeight','bold','Color','k');
        ylabel(h_DepChAlpTrials,'Ch Alpha Pow (db)  ','FontSize',8,'FontWeight','bold','Color','k');
        hold(h_DepChAlpTrials,'off') 
    end
    
   % Creating Alpha Independent matrix
    
    if size(ind_alphaInd,2) >= 1
        for i = 1:size(ind_alphaInd,2)
            rowval              = ind_alphaInd(i);
            alpIndPowData(:,i)  = mean(subdata{6,rowval});
        end
        avgtime_alpIndPowData   = 10*mean(alpIndPowData(calibrationDurationS+1:totTimeToPlot,:),1);
        AllTrails_alpIndPowData = mean(avgtime_alpIndPowData); stderr_AllTrails_alpIndPowData = std(avgtime_alpIndPowData)/sqrt(size(avgtime_alpIndPowData,2));
        if size(ind_alphaInd,2) == 1
            stderr_alpaIndData  = (std(alpIndPowData))/sqrt(size(TrialsAlphaPow,1));
            stderr_alpaIndData  = repmat(stderr_alpaIndData ,1,size(avgtime_alpIndPowData,2));
        else
            stderr_alpaIndData  = (std(alpIndPowData))/sqrt(size(TrialsAlphaPow,1));
        end
        plot(h_IndChAlpTrials,indtraialno,avgtime_alpIndPowData,'g-*'); hold(h_IndChAlpTrials,'on')  
        hc =  errorbar(h_IndChAlpTrials,indtraialno,avgtime_alpIndPowData,stderr_alpaIndData,stderr_alpaIndData ,'.','MarkerSize',5,...
        'MarkerEdgeColor','g','MarkerFaceColor','g');
        set(hc,'color','g');
        % set(gca,'XTickLabel',{'1','2','3','4'});
        title(h_IndChAlpTrials,'Independent feedback','FontSize',10,'FontWeight','bold','Color','k');
        xlabel(h_IndChAlpTrials,'TrialNumber','FontSize',8,'FontWeight','bold','Color','k');
        ylabel(h_IndChAlpTrials,'Ch Alpha Pow (db)','FontSize',8,'FontWeight','bold','Color','k');
        hold(h_IndChAlpTrials,'off') 
    end

    
    % Session Summary 
    
    trialtypes = 1:3;  % x axis
    
    if (size(ind_alphaInd,2) >= 1 && size(ind_alphaDep,2) >= 1 && size(ind_Cons,2) >= 1)
        
        cla(h_changeAlphaTrials);
        hold(h_changeAlphaTrials,'on')
        hcons   =  errorbar(h_changeAlphaTrials,ind_Cons,AllTrialsMeanAlphaPow(ind_Cons),error_all(ind_Cons),error_all(ind_Cons),'.','MarkerSize',10,...
                    'MarkerEdgeColor','b','MarkerFaceColor','b');  
        set(hcons,'color','b');
        hdep    = errorbar(h_changeAlphaTrials,ind_alphaDep,AllTrialsMeanAlphaPow(ind_alphaDep),error_all(ind_alphaDep),error_all(ind_alphaDep),'.','MarkerSize',10,...
                    'MarkerEdgeColor','m','MarkerFaceColor','m');
        set(hdep,'color','m');
        hind    =  errorbar(h_changeAlphaTrials,ind_alphaInd,AllTrialsMeanAlphaPow(ind_alphaInd),error_all(ind_alphaInd),error_all(ind_alphaInd),'.','MarkerSize',10,...
                    'MarkerEdgeColor','g','MarkerFaceColor','g');
        set(hind,'color','g');
        plot(h_changeAlphaTrials,trials,AllTrialsMeanAlphaPow,'k-');
        xlim(h_changeAlphaTrials,[0 (size(AllTrialsMeanAlphaPow,2)+1)]);
        xlabel(h_changeAlphaTrials,'Trials','FontSize',10,'FontWeight','bold','Color','k'); 
        ylabel(h_changeAlphaTrials,'Ch Alpha Pow (db)','FontSize',10,'FontWeight','bold','Color','k');      
        hold(h_changeAlphaTrials,'off')
        
        %% Session Summary
        Avg_changePower = [AllTrails_alpConsPowData,AllTrails_alpDepPowData,AllTrails_alpIndPowData];
        error_upper      = [stderr_AllTrails_alpConsPowData,stderr_AllTrails_alpDepPowData,stderr_AllTrails_alpIndPowData];
        error_lower      = [0,0,0];
        bar(h_SessionSummary,trialtypes,Avg_changePower); hold(h_SessionSummary,'on');
        hc = errorbar(h_SessionSummary,trialtypes,Avg_changePower,error_lower,error_upper,'.','MarkerSize',20,...
            'MarkerEdgeColor','cyan','MarkerFaceColor','cyan');
        set(hc,'color','r')
        set(h_SessionSummary,'XTickLabel',{'Constant','Alpha Dependent','ALpha InDependent'});
        xlabel(h_SessionSummary,'Trialtypes','FontSize',8,'FontWeight','bold','Color','k');
        ylabel(h_SessionSummary,'Change in Alphapower(db)','FontSize',8,'FontWeight','bold','Color','k');
        title(h_SessionSummary,'Avg ChAlphaPow diff trial','FontSize',8,'FontWeight','bold','Color','k');
        hold(h_SessionSummary,'off');
        
    end
    
    
end
