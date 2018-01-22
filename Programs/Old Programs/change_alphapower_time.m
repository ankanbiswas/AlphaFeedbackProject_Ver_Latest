
% Analysis script one
% For plotting change in alpha power with time
% Avarage across all the trials

function [] = change_alphapower_time(handles,subdata)

    h_changeAlphaTime       = handles.changeAlphaTime;
    h_ConsChAlpTime         = handles.ConsChAlpTime; 
    h_DepChAlpTime          = handles.DepChAlpTime;
    h_IndChAlpTime          = handles.IndChAlpTime;
    calibrationDurationS    = handles.calibrationDurationS;
    runtimeDurationS        = handles.runtimeDurationS     ;
    totTimeToPlot           = calibrationDurationS + runtimeDurationS ;

    totalTrialno    = size(subdata,2); % The column size of the data structure is the indication of the total trialno
    TrialsAlphaPow  = [];



    %%
    for i = 1:totalTrialno
        meanAlphaPow        = mean(subdata{6,i},1);
        TrialsAlphaPow      = [TrialsAlphaPow;meanAlphaPow];
    end
 
    AllTrialsMeanAlphaPow   = 10*(mean(TrialsAlphaPow,1)); % converting into db by multiplication of 10 : 10*log(a/b)
    
    if size(TrialsAlphaPow,1) == 1
        error_MeanAlphaPow  = (std(TrialsAlphaPow)/sqrt(size(TrialsAlphaPow,1)));
        error_MeanAlphaPow  =  repmat(error_MeanAlphaPow,1,size(TrialsAlphaPow,2));
    else
        error_MeanAlphaPow  = (std(TrialsAlphaPow)/sqrt(size(TrialsAlphaPow,1)));
    end
     
    time                    = 1:totTimeToPlot;
    cla(h_changeAlphaTime);
    axes(h_changeAlphaTime);
    shadedErrorBar(time,AllTrialsMeanAlphaPow ,error_MeanAlphaPow ,'b');
%     plot(h_changeAlphaTime,time,AllTrialsMeanAlphaPow);
    xlabel(h_changeAlphaTime,'Time(sec)','FontSize',10,'FontWeight','bold','Color','k');
    ylabel(h_changeAlphaTime,'Ch Alpha Pow (db)','FontSize',10,'FontWeight','bold','Color','k');
    hold(h_changeAlphaTime,'off');

    % Saving the current axes as a new figure
%     fig2    = figure('visible','off');
%     newax   = copyobj(h_changeAlphaTime, fig2);
%     set(newax, 'units', 'normalized', 'position', [0.13 0.11 0.775 0.815]);
%     print(fig2,'Average alpha power vs. time','-dpng');
%     hgsave(fig2,'Average alpha power vs. time')    % save it
% 
%     % saveas(fig2,'Average alpha power vs. time.fig','fig');
%     close(fig2)                                    % clean up by closing it


    %% Subdividing the plot into trialtypes

     trialType      = [subdata{2,1:end}];
     ind_Cons       = find(trialType==0);
     ind_alphaDep   = find(trialType==1);
     ind_alphaInd   = find(trialType==2);


    % Creating consdata matrix and ploting
    if size(ind_Cons,2) >= 1
        for i = 1:size(ind_Cons,2)
            rowval              = ind_Cons(i);
            alpConsPowData(i,:)  = mean(subdata{6,rowval});
        end
        avgtime_alpConsPowData = mean(alpConsPowData,1);  
        if size(ind_Cons,2) == 1
            stderr_alpaConsData  = (std(alpConsPowData))/sqrt(size(ind_Cons,2));
            stderr_alpaConsData  = repmat(stderr_alpaConsData,1,size(avgtime_alpConsPowData,2));
        else
            stderr_alpaConsData  = (std(alpConsPowData))/sqrt(size(ind_Cons,2));
        end
        cla(h_ConsChAlpTime);
        axes(h_ConsChAlpTime);
        shadedErrorBar(time,10*avgtime_alpConsPowData,stderr_alpaConsData ,'b');
        xlabel(h_ConsChAlpTime,'Time(sec)','FontSize',8,'FontWeight','bold','Color','k'); 
        ylabel(h_ConsChAlpTime,'Ch Alpha Pow (db)','FontSize',8,'FontWeight','bold','Color','k');
        title(h_ConsChAlpTime ,'Constant Feedback','FontSize',10,'FontWeight','bold','Color','k');
        hold(h_ConsChAlpTime,'off');

    end

    % Creating AlphaDependent matrix and ploting
    if size(ind_alphaDep,2) >= 1
        for i = 1:size(ind_alphaDep,2)
            rowval              = ind_alphaDep(i);
            alpDepPowData(i,:)  = mean(subdata{6,rowval});   
        end
        avgtime_alpaDepData = mean(alpDepPowData,1);  
        if size(ind_alphaDep,2) == 1
            stderr_alpaDepData  = (std(alpDepPowData))/sqrt(size(ind_alphaDep,2));
            stderr_alpaDepData  = repmat(stderr_alpaDepData,1,size(avgtime_alpaDepData,2));
        else
            stderr_alpaDepData  = (std(alpDepPowData))/sqrt(size(ind_alphaDep,2));
        end
        cla(h_DepChAlpTime);
        axes(h_DepChAlpTime);
        shadedErrorBar(time,10*avgtime_alpaDepData,stderr_alpaDepData ,'m');
        xlabel(h_DepChAlpTime,'Time(sec)','FontSize',8,'FontWeight','bold','Color','k'); 
        ylabel(h_DepChAlpTime,'Ch Alpha Pow (db)','FontSize',8,'FontWeight','bold','Color','k');
        title(h_DepChAlpTime ,'AlphaDep Feedback','FontSize',10,'FontWeight','bold','Color','k');
        hold(h_DepChAlpTime,'off');
    end

    % Creating InDependent matrix and ploting
    if size(ind_alphaInd,2) >= 1
        for i = 1:size(ind_alphaInd,2)
            rowval              = ind_alphaInd(i);
            alpIndPowData(i,:)  = mean(subdata{6,rowval});   
        end
        avgtime_alpIndPowData = mean(alpIndPowData,1);  
        if size(ind_alphaInd,2) == 1
            stderr_alpaIndData  = (std(alpIndPowData))/sqrt(size(ind_alphaInd,2));
            stderr_alpaIndData  = repmat(stderr_alpaIndData,1,size(avgtime_alpIndPowData,2));
        else
            stderr_alpaIndData  = (std(alpIndPowData))/sqrt(size(ind_alphaInd,2));
        end
        cla(h_IndChAlpTime);
        axes(h_IndChAlpTime);
        shadedErrorBar(time,10*avgtime_alpIndPowData,stderr_alpaIndData ,'g');
        xlabel(h_IndChAlpTime,'Time(sec)','FontSize',8,'FontWeight','bold','Color','k'); 
        ylabel(h_IndChAlpTime ,'Ch Alpha Pow (db)','FontSize',8,'FontWeight','bold','Color','k');
        title(h_IndChAlpTime,'AlphaIndDep Feedback','FontSize',10,'FontWeight','bold','Color','k');
        hold(h_IndChAlpTime,'off');
    end

    drawnow
end
