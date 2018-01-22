

function Biofeedback_recording_interface

    % Creating a figure to house the GUI
    figure; 

    % Defining basic positions
    xstart = 0.01; ystart = 0.05; boxwidth = 0.07; gap = 0.02; yini = 0.55;
    yControlStart = 0.2;

    % Creating editbox for taking the frequency components
    % Frequency Range for analysis 
    
    uicontrol('Style','text',...
                        'Unit','Normalized',...
                        'Position',[xstart  0.85  0.14  0.1],...
                        'String','Subject Name');                  

    hsubjectname = uicontrol('style','edit',...
                        'String','test',...
                        'Unit','Normalized',...
                        'Position', [(xstart+boxwidth)/2.3   0.85-gap   boxwidth*1.2   boxwidth]);
    
    uicontrol('Style','text',...
                        'Unit','Normalized',...
                        'Position',[xstart  0.7  0.14  0.1],...
                        'String','Session No');                  

    hsessionNo = uicontrol('style','edit',...
                        'String','1',...
                        'Unit','Normalized',...
                        'Position', [(xstart+boxwidth)/2   0.7-gap   boxwidth   boxwidth]);

    uicontrol('Style','text',...
                        'Unit','Normalized',...
                        'Position',[xstart  yini  0.12  0.1],...
                        'String','Alpha Range');

    hAlphaMin = uicontrol('style','edit',...
                        'String','8',...
                        'Unit','Normalized',...
                        'Position', [xstart   yini-gap   boxwidth   boxwidth]);

    hAlphaMax = uicontrol('style','edit',...
                        'String','13',...
                        'Unit','Normalized',...
                        'Position', [xstart+(boxwidth)  yini-gap   boxwidth  boxwidth]);   
                    
    uicontrol('Style','text',...
                        'Unit','Normalized',...
                        'Position',[0.008  0.40  0.05  0.1],...
                        'String','Trial No');
   
    hTrialNo = uicontrol('style','edit',...
                        'string','1',...
                        'Unit','Normalized',...
                        'Position', [0.01   0.40-gap   0.05   boxwidth]);
                    
    uicontrol('Style','text',...
                        'Unit','Normalized',...
                        'Position',[0.008+0.07  0.40  0.05  0.1],...
                        'String','Trial type');
            
    hTrialTypes = uicontrol('style','edit',...
                        'string','1',...
                        'Unit','Normalized',...
                        'Position', [0.01+boxwidth   0.40-gap   0.053   boxwidth]);
                    
    uicontrol('style', 'text',...
                        'string', 'Start',...
                        'Unit','Normalized',...
                        'Position', [xstart  yControlStart+boxwidth  boxwidth  boxwidth],...
                        'String','Data Loss');                
    hDataLoss = uicontrol('style','edit',...
                        'string', 'No',...
                        'Unit','Normalized',...
                        'Position', [xstart+(boxwidth)   yControlStart+boxwidth   boxwidth  boxwidth]);                
                    
    % Creating pushbuttons 
    hStart = uicontrol('style', 'pushbutton',...
                        'string', 'Start',...
                        'Unit','Normalized',...
                        'Position', [xstart  yControlStart  boxwidth  boxwidth],...
                        'Callback',{@Callback_Start});

    hStop = uicontrol('style', 'pushbutton',...
                        'string', 'Stop',...
                        'Unit','Normalized',...
                        'Position', [xstart+(boxwidth)   yControlStart   boxwidth  boxwidth],...
                        'callback',{@Callback_Stop});

    hCalibrate = uicontrol('style', 'pushbutton',...
                        'string', 'Calibrate',...
                        'Unit','Normalized',...
                        'Position', [xstart  yControlStart-boxwidth  boxwidth  boxwidth],...
                        'Callback',{@Callback_Calibrate});

    hRun = uicontrol('style', 'pushbutton',...
                        'string', 'Run',...
                        'Unit','Normalized',...
                        'Position', [xstart+(boxwidth)   yControlStart-boxwidth   boxwidth  boxwidth],...
                        'Callback',{@Callback_Run}); 
   
    hAnalysis = uicontrol('style', 'pushbutton',...
                        'string', 'Analysis',...
                        'Unit','Normalized',...
                        'Position', [xstart+(boxwidth)   yControlStart-boxwidth*2   boxwidth  boxwidth],...
                        'Callback',{@Callback_Analysis});      
    hClearPlots = uicontrol('style', 'pushbutton',...
                        'string', 'ClearPlots',...
                        'Unit','Normalized',...
                        'Position', [xstart   yControlStart-boxwidth*2   boxwidth  boxwidth],...
                        'Callback',{@Callback_ClearPlots});
    hExit = uicontrol('style', 'pushbutton',...
                        'string', 'Exit',...
                        'Unit','Normalized',...
                        'Position', [xstart   yControlStart-boxwidth*3   boxwidth  boxwidth],...
                        'Callback',{@Callback_Exit}); 
                    
    % Creating plot axes
    plot_xstart             = xstart+(boxwidth*2.5); plot_ystart = ystart;
    plot_delX               = 1-ystart*4; plot_delY = 1-ystart*1.5;

    plotPos                 = [plot_xstart,plot_ystart,plot_delX,plot_delY];
    [~,~,gridPos]           = getPlotHandles(4,1,plotPos,0.05,0.05,0);

    hRawTrace               = getPlotHandles(1,1,[plot_xstart,0.7813,0.515,0.1938],0.05,0.05,0);
    hCheckBaselinePower     = getPlotHandles(1,1,[0.7517,0.7813,0.235,0.1938],0.05,0.05,0);
    hTF                     = getPlotHandles(1,1,[plot_xstart,0.5375,0.515,0.1938],0.05,0.05,0);
    hPSD                    = getPlotHandles(1,2,[0.7517,0.5375,0.235,0.1938],0.05,0.05,0);
    AnalysisPlotHandles     = getPlotHandles(1,3,gridPos{3,1},0.05,0.05,0);
    AnalysisPlotHandles_2   = getPlotHandles(1,6,gridPos{4,1},0.025,0.05,0);

    % Getting plot handles
    
    handles.hRawTrace           = hRawTrace;
    handles.checkBaselinePower  = hCheckBaselinePower;
    handles.hTF                 = hTF;
    handles.hPSD                = hPSD;
    handles.changeAlphaTime     = AnalysisPlotHandles(1,1); 
    handles.changeAlphaTrial    = AnalysisPlotHandles(1,2);
    handles.SessionSummary      = AnalysisPlotHandles(1,3);
    
    handles.ConsChAlpTime       = AnalysisPlotHandles_2(1,1); 
    handles.DepChAlpTime        = AnalysisPlotHandles_2(1,2);
    handles.IndChAlpTime        = AnalysisPlotHandles_2(1,3);
    
    handles.ConsChAlpTrials     = AnalysisPlotHandles_2(1,4); 
    handles.DepChAlpTrials      = AnalysisPlotHandles_2(1,5);
    handles.IndChAlpTrials      = AnalysisPlotHandles_2(1,6);
    
    
    drawnow  % Updates the figure

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%####### Total No Of Trials ########%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Creating the array of trialtypes
    % Defining zero for the constant tone    (25% of the total trials),
    % Defining one for the dependent tone    (50% of the total trials),
    % Defining two for the independent tone  (25% of the total trial)
    % Generating ones, twos and zeros accordingly 
    
    firstSessTrialNo     = 12;
    tot_trials           = 60; % defining total number of trials in a session
    tot_AllSessExF       = tot_trials - firstSessTrialNo;
    handles.tot_trials   = tot_trials;
    
    firstSessTrialTypes  = [zeros(firstSessTrialNo/4,1); ones(firstSessTrialNo-(firstSessTrialNo/4),1)]';      
    trialtype_AllSessExF = [zeros(tot_AllSessExF /4,1);ones(tot_AllSessExF /2,1);repmat(2,tot_AllSessExF /4,1)]';
    
    for i = 1:100 % shuffling well the trialtypes
        firstSessTrialTypes  = firstSessTrialTypes(randperm(firstSessTrialNo));  
        trialtype_AllSessExF = trialtype_AllSessExF(randperm(tot_AllSessExF ));
    end
    
    trialtype = [firstSessTrialTypes trialtype_AllSessExF];
    disp(trialtype);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    start_value = 1;
    end_value   = tot_trials;
   
    trialNo     = start_value;
    subjectname = get(hsubjectname,'string');
    sessionNo   = get(hsessionNo,'string');
    tag         = [subjectname '_ses_'  sessionNo];
      
   
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
   % Initializing the parameters for the main programme

    state           = 0; % by default state is zero which would be updated according to the case
    Fs              = 500;
    sampleDurationS = 1;
    timeValsS       = 0:1/Fs:sampleDurationS-1/Fs;
    timeStartS      = 0;
    fullDisplayDurationS = 60;
    
    % defining default variables for the starttime
    stcount     = 1;
    blcount     = 1;
%     EXPcount  = 1;
%     btcount   = 1;
    dataTemp    = [];
    timeTemp    = [];
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Calibrattion and runtime durations %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % defining default variables for the calibration 
    calibrationDurationS = 10; 
    runtimeDurationS     = 50;

    handles.fullDisplayDurationS =  fullDisplayDurationS;
    handles.calibrationDurationS =  calibrationDurationS;
    handles.runtimeDurationS     =  runtimeDurationS;

%     AlphaChans = [1 2 3 4 5];           % The channels from which the data is extracted
       
    BDstart         = 1;
    EXPstart        = (calibrationDurationS + sampleDurationS); % which is the 11th second from which to start from 
    EXPcount        = 1;
    dataExpBegin    = (Fs*EXPstart)+1;
    
    powerTemp       = zeros(51,fullDisplayDurationS);
    
    blDataTemp      = zeros(5,Fs*calibrationDurationS);
    EXPdataTemp     = zeros(5,Fs*(calibrationDurationS+runtimeDurationS)) ;
    blPowerTemp     = zeros(51,calibrationDurationS);
    EXPpowerTem     = zeros(51,(calibrationDurationS+runtimeDurationS));
    
    % Initialization for the soundtone feedback
    smoothKernel    = repmat(1/10,1,5);
    epochsToAvg     = length(smoothKernel);  
    Fsound          = 44100;  % need a high enough value so that alpha power below baseline can be played
    Fc              = 500; 
    Fi              = 800;
    
    % Opening the RDA port as the GUI is shown
    [cfg,sock]      = rda_open;                      
    if sock == -1
        hdr = 100;      
    else
        hdr         = rda_header(cfg,sock); % rda_open would pass the sokect information
    end
    
    % Inserting the relaxation and sustainance quoteient
    analysisRange   = calibrationDurationS:runtimeDurationS;
    rawstpower      = [];
    
    % Intializing structure for the saving the data
     subdata        = {};
     setfreqdata    = [];
     incrFactData   = [];
     
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    while 1

    %     Get alpha Range
    %     Do time-frequency analysis to get PSD
    %     AB: Everything above can be done in a single function instead of
    %     passing the data from one to another. 
    
    %     Get the data and get the psd
    %     also, but dont plot
    
%         [raw, SQN]      = rda_message(sock,hdr);    % reading rda message
        alphaLowFreq    = str2double(get(hAlphaMin,'string'));
        alphaHighFreq   = str2double(get(hAlphaMax,'string'));
        subjectname     = get(hsubjectname,'string');
        sessionNo       = get(hsessionNo,'string');
        numSessionNo    = str2double(sessionNo);
        
        tag             = [subjectname '_ses_'  sessionNo];
  
        if state == 0 % Idle state
            timeStartS = 0; % dont do anything

        elseif state == 1 % Start
            [raw, SQN] = rda_message(sock,hdr); 
            % get the time axis and plot one second of the data
            if stcount == 2
                cla(hRawTrace);
                cla(hTF);
            end
            
            stcount                 = 1;
            X                       = raw.data;           
            timeToUse               = timeStartS + timeValsS;
            timeToPlot              = [timeTemp timeToUse];
            datatoplot              = [dataTemp X];
            timeStartS              = timeStartS+sampleDurationS; 
            powerTemp(:,timeStartS) = raw.meanPower;
            ch_meanRawPower         = powerTemp;
            ch_meanRawPower         = ch_meanRawPower(:,any(ch_meanRawPower));
            freq                    = raw.freq;
            
            checkplot_time(state,handles,timeToPlot,datatoplot,freq,ch_meanRawPower); 
            
            dataTemp                = X(:,end);
            timeTemp                = timeToUse(end);
            if timeStartS==fullDisplayDurationS
                dataTemp    = [];
                timeTemp    = [];
                timeStartS  = 0;
                cla(hRawTrace);
                cla(hTF);
                powerTemp   = zeros(51,fullDisplayDurationS);
            end   
           
        elseif state == 2 % Stop
            dataTemp    = [];
            timeTemp    = [];
            stcount     = 1;
            timeStartS  = 0;           
            powerTemp   = zeros(51,fullDisplayDurationS);
            stcount     = stcount+1;
            cla(hRawTrace);
            cla(hTF);
%             rda_close(sock); 
%             powerTemp = zeros(51,fullDisplayDurationS);


        elseif state == 3 % Calibrate
            [raw, SQN]  = rda_message(sock,hdr); 
            t_type      = trialtype(1,trialNo);
            str_trialno = num2str(trialNo);
            str_t_type  = num2str(t_type);
            set(hTrialTypes,'string',str_t_type);          
           
            if blcount == 2
                cla(hRawTrace);
                cla(hTF);
                BDstart = 1;
            end
            blcount = 1;
                        
            if timeStartS < calibrationDurationS
                % Display PSD and T-F plot as before
                % Save PSD data in a larger array
                % compute alpha power                
                X           = raw.data; 
                BDstop      = ((BDstart+Fs)-1);
                timeToUse   =  timeStartS + timeValsS;
                timeToPlot  = [timeTemp timeToUse];
                datatoplot  = [dataTemp X];
                timeStartS  = timeStartS+sampleDurationS; 
                
                blDataTemp(:,BDstart:BDstop) = X; 
                blPowerTemp(:,timeStartS)    = raw.meanPower;
                ch_meanRawPower              = blPowerTemp;
                ch_meanRawPower              = ch_meanRawPower(:,any(ch_meanRawPower));
                freq                         = raw.freq;
                checkplot_time(state,handles,timeToPlot,datatoplot,freq,ch_meanRawPower); 
                dataTemp                     = X(:,end);
                timeTemp                     = timeToUse(end);
                BDstart                      = BDstart+Fs;
            
                SQN = [SQN SQN]; % Checking the data loss             
                
            elseif timeStartS == calibrationDurationS
                % Save the entire calibarion data in a separate file
%               timeStartS=timeStartS+sampleDurationS;
                dataTemp        = [];
                timeTemp        = [];
                blData          = blDataTemp;
                rawBlPower      = blPowerTemp;             %  Rawbaselinepower
                meanBlPower     = mean(rawBlPower,2);
                logMeanBLPower  = conv2Log(meanBlPower);
                ch_blpower      = (conv2Log(rawBlPower) - repmat(logMeanBLPower,1,calibrationDurationS));
                blDataTemp      = zeros(5,Fs*calibrationDurationS);
                blPowerTemp     = zeros(51,calibrationDurationS);
                blcount = blcount+1;
%                 cla(hRawTrace);   
%                 cla(hTF);
                %% Ploting and saving the mean alpha raw baseline power
                
                blPowerToplot           = mean(rawBlPower,2);
                plot(handles.hPSD(1,1),freq',blPowerToplot,'color',[0.7 0.7 0.7]);                
                xlabel(handles.hPSD(1,1), 'Frequency (Hz)');
                ylabel(handles.hPSD(1,1), 'Change in Pow');
                xlim(handles.hPSD(1,1),[0 30]); 
                ylim(handles.hPSD(1,1),[0 10]);
                
                TrialToPlot         = trialNo;
                meanRawBlPower      = mean(mean(rawBlPower(alphaLowFreq:alphaHighFreq,:),2),1);
                hCheckBaselinePower = handles.checkBaselinePower;
                set(hCheckBaselinePower,'XLim',[0 tot_trials]); % Setting the xlim 
                xlabel(hCheckBaselinePower, 'Trial No'); ylabel(hCheckBaselinePower, 'mean RawBl Pow');
                plot(hCheckBaselinePower,TrialToPlot,meanRawBlPower,'r*'); hold(hCheckBaselinePower,'on');
                
                % saving the baseline data
                
%                 tagsave = [tag 'trial_' str_trialno 'ttype_' str_t_type];
                tagsave = [tag 'trial_' str_trialno];
                save(['BF_BlData_' tagsave],'blData','rawBlPower'); % in future include specific file name
%                 tag     =  [subjectname '_ses_'  sessionNo];
                state = 0;
                
                %% Cheking the data loss
                dl = unique(diff(SQN));
                disp(dl);
                if dl ==1
                    set(hDataLoss,'string','No Loss');
                else
                    set(hDataLoss,'string','Yes');
                end
            end

        elseif state == 4 % run Experiment
            [raw, SQN]      = rda_message(sock,hdr); 
%               if timeStartS < runtimeDurationS 
                % Display PSD and T-F plot as before Save PSD data in a
                % larger array compute alpha power

                if (EXPcount == 1)
                    % Getting current loop data: PN: the power data is
                    % already in log format
                    X           = raw.data; 
                    freq        = raw.freq;
                    power       = raw.meanPower;
                    rawstpower  = power;
                    logPower    = conv2Log(power);
                    ch_stPower  = logPower - logMeanBLPower;
                    
                    % Getting the baseline power and data from the previous loop run    
                    % Now: Making sure that the basline saves and passes me
                    % the data for the baselineperiod seconds
                    
                    combData        = [blData X];                % concatenating the bldata with  the data in that loop
                    combRawPower    = [rawBlPower rawstpower]; 
                    combPower       = [ch_blpower ch_stPower];  % similarly for the blpower
                    % Substracting the meanpower of the baseline from the
                    % baseline raw power
                                          
                    for i = 1:size(combData,2)
                        EXPdataTemp(:,i) = combData(:,i);                         
                    end
                  
                    EXPpowerTem(:,1:EXPstart)   = combPower;
                    total_time                  = calibrationDurationS + EXPcount;
                    ExptimeValsS                = 0:1/Fs:total_time-1/Fs;
                    ExptimeTemp                 = ExptimeValsS(end);
                    ExptempData                 = X(:,end);
                    
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    if(t_type == 1)
                        disp('playing alpha dependent tone');
                        incrFact(EXPcount)  = mean(mean(combPower(alphaLowFreq:alphaHighFreq,end-epochsToAvg+1:end)'*smoothKernel(1,1)));
                        stFreq              = round(Fc + incrFact(EXPcount) * Fi);
                        soundTone           = sine_tone(Fsound ,1,stFreq);
                        sound(soundTone,Fsound);
                        setfreqdata         = stFreq;
                        incrFactData        = incrFact;
                    elseif(t_type == 0)
                        disp('playing constant tone');
                        incrFact(EXPcount)  = 0; % there is no increment in the tone for the constant tone
                        stFreq              = Fc;
                        soundTone           = sine_tone(Fsound ,1,stFreq);
                        sound(soundTone,Fsound);
                        setfreqdata         = stFreq;
                        incrFactData        = incrFact;
                    elseif(t_type ==2) 
                        disp('playing alpha independent tone');
%                         incrFact(EXPcount)  = mean(mean(combPower(betaLowerLimit:betaUpperLimit,end-epochsToAvg+1:end)'*smoothKernel(1,1)));                        
%                         stFreq              = round(Fc + incrFact(EXPcount) * Fi);
                        stFreq              = setfreqtouse(EXPcount);        
                        soundTone           = sine_tone(Fsound,1,stFreq);
                        sound(soundTone,Fsound);
                        setfreqdata         = stFreq;
                        incrFactData        = incrFact;
                    end
                    
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    
                    checkplot_time_2(handles,ExptimeValsS,combData,freq,combPower,combRawPower); % plotting the total baselinedurationS+1 seconds of data
%                   EXPcount = EXPcount+1;  
                   
                    
                elseif (EXPcount<(runtimeDurationS+1))
                    
                    % getting and plotting rawdata
                    X = raw.data; % get the rawdata
                    % get the time axis which starts from baselineDurations
                   
                    SQN        = [SQN SQN];
                    dataExpEnd = ((dataExpBegin+Fs)-1);
                    timeToUse  = EXPstart + timeValsS;
                    timeToPlot = [ExptimeTemp timeToUse];
                    EXPstart   = EXPstart + sampleDurationS;
                    datatoplot = [ExptempData X]; % concatenating recent loops data with the previous loops data 

                    EXPdataTemp(:,dataExpBegin:dataExpEnd) = X;
                    % Getting and plotting powerdata
                    % In each loop the power data is collected 
                    exp_power       = raw.meanPower;
                    combRawPower    = [combRawPower exp_power]; % combined all the powervals starting from baseline time 
                    rawstpower      = [rawstpower exp_power];
                    ch_power        = conv2Log(exp_power)- logMeanBLPower; % Calcualting changeinpower
                    EXPpowerTem(:,EXPstart) = ch_power;
                    ch_meanRawPower = EXPpowerTem;
                    ch_meanRawPower = ch_meanRawPower(:,any(ch_meanRawPower));
                    freq            = raw.freq;                    
                    
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
                    if(t_type == 1)
                        disp('playing alpha dependent tone');
                        incrFact(EXPcount)  = mean(mean(ch_meanRawPower(alphaLowFreq+1:alphaHighFreq+1,end-epochsToAvg+1:end)'*smoothKernel(1,1)));
                        stFreq              = round(Fc + incrFact(EXPcount) * Fi);
                        soundTone           = sine_tone(Fsound ,1,stFreq);
                        disp(incrFact(EXPcount));
                        disp(stFreq);
                        sound(soundTone,Fsound);
                        setfreqdata         = [setfreqdata stFreq];
                        incrFactData        = [incrFactData incrFact];
                    elseif(t_type == 0)
                        disp('playing constant tone');
                        stFreq              = Fc;
                        incrFact(EXPcount)  = 0; % there is no increment in the tone for the constant tone
                        soundTone           = sine_tone(Fsound ,1,stFreq);
                        sound(soundTone,Fsound);
                        setfreqdata         = [setfreqdata stFreq];
                        incrFactData        = [incrFactData incrFact];
                    elseif(t_type ==2) 
                        disp('playing alpha independent tone');
%                         incrFact(EXPcount)  = mean(mean(ch_meanRawPower(betaLowerLimit+1:betaUpperLimit+1,end-epochsToAvg+1:end)'*smoothKernel(1,1)));
%                         stFreq              = round(Fc + incrFact(EXPcount) * Fi);
                        stFreq              = setfreqtouse(EXPcount); 
                        soundTone           = sine_tone(Fsound ,1,stFreq);
                        sound(soundTone,Fsound);
                        setfreqdata         = [setfreqdata stFreq];
                        incrFactData        = [incrFactData incrFact];
                    end
                    
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    
                    checkplot_time_2(handles,timeToPlot,datatoplot,freq,ch_meanRawPower,combRawPower); 
                    dataExpBegin    = dataExpBegin+Fs;
                    ExptempData     = X(:,end);
                    ExptimeTemp     = timeToUse(end);
                    
                elseif(EXPcount==(runtimeDurationS + 1)) 
                    ExptempData         = [];
                    ExptimeTemp         = [];
                    CombExpRawData      = EXPdataTemp;
                    CombExpPowerData    = EXPpowerTem;
                    CombRawPowerData    = combRawPower;
                    EXPdataTemp = zeros(5,Fs*(calibrationDurationS + runtimeDurationS)); % returned back to the initial dataterm
                    EXPpowerTem = zeros(51,(calibrationDurationS + runtimeDurationS));   % returned back to initial powerterm
                    
                    
                    %% Calculating relaxation and sustenance quotient
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  msgbox    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                   
                    blPowerArray = mean(rawBlPower(alphaLowFreq:alphaHighFreq,3:calibrationDurationS),2);
                    stPowerArray = mean(rawstpower(alphaLowFreq:alphaHighFreq,analysisRange),2);
                    changeArray  = stPowerArray/mean(blPowerArray) - 1;
                    relquot      = 100*mean(changeArray);
                    fluct        = std(stPowerArray)/mean(stPowerArray);
                    susqut       = (int64(100*(1/fluct)));
                    
                    % show a message box % for now showing only relaxation
                    % quotient but saving both rexation and sustenance quotiont 
%                     msgbox(['Your relaxation quotient is ' num2str(relquot)], 'EEG Demo', 'help');
%                    set(h,'Position',[160 300 700 80]);
                   
                    dl = unique(diff(SQN));      % Checking for data loss
                    disp(dl);
                    
                    if dl ==1
                        set(hDataLoss,'string','No Loss');
                    else
                        set(hDataLoss,'string','Yes');
                    end
            
                    % Saving data in a way (in each separate mat file)
%                     tagsave = [tag 'trial_' str_trialno 'ttype_' str_t_type];
                    tagsave = [tag 'trial_' str_trialno];
%                     save(['BF_ExData_' tagsave],'CombExpRawData','CombExpPowerData'); % save the data 
                    state = 0;                                                          % returing to the default state                       
                    tag =  [subjectname '_ses_'  sessionNo];   
                    
                                                       
                    %% Saving the data in cell array structures:                 
                   
        
                    subdata{1,trialNo}  = trialNo;              %(1) trialno              
                    subdata{2,trialNo}  = t_type;               %(2) trialtypes                   
                    subdata{3,trialNo}  = CombExpRawData;       %(3) rawdata        (bl+st)                    
                    subdata{4,trialNo}  = CombRawPowerData;     %(4) rawpower       (bl+st)                   
                    subdata{5,trialNo}  = CombExpPowerData;     %(5) changein power (bl+st)                    
                    AlphachPowerData    = CombExpPowerData(alphaLowFreq+1:alphaHighFreq+1,:); 
                    subdata{6,trialNo}  = AlphachPowerData;     %(6) AlphachPowerData                     
                    subdata{7,trialNo}  = incrFactData;         %(7) incrfact                    
                    subdata{8,trialNo}  = setfreqdata;          %(8) setfreqdata                    
                    subdata{9,trialNo}  = relquot;              %(9) relquot                   
                    subdata{10,trialNo} = susqut;               %(10) susquot
                    
                    save(['BF_' tag],'subdata');             % where tag is tag =  [subjectname '_ses_'  sessionNo];  
                    save(['BF_ExData_' tagsave],'subdata');  % saving the data as separate mat file after each trial
                    
                    %% Analysing the data and plotting
                    
                    change_alphapower_time(handles,subdata);
                    change_alphapower_trials(handles,subdata);
                    msgbox(['Your relaxation quotient is ' num2str(relquot)], 'EEG Demo', 'help');
             
                end
                
                if (EXPcount == (runtimeDurationS+1))
                    EXPcount        = 1;
                    EXPstart        = (calibrationDurationS+1);
                    dataExpBegin    = (Fs*EXPstart)+1;        % Reinitializing dataExpBegin
                    combData        = [];
                    combPower       = [];
                    trialNo         = trialNo+1;
                    % Setting the trial no in the gui
                    set(hTrialNo,'string',num2str(trialNo));
                    t_type          = trialtype(1,trialNo);
                    str_t_type      = num2str(t_type);
                    set(hTrialTypes,'string',str_t_type);
                    
                    if trialNo == 13
                        trialtolookfor          = trialtype(1:12);
                        ind_alpDepTrial         = find(trialtolookfor==1);
                        alpDepSetFreqData       = [];
                        for i = 1:size(ind_alpDepTrial,2)
                            indToExtract        = ind_alpDepTrial(i);
                            alpDepSetFreq       = subdata{8,indToExtract};
                            alpDepSetFreqData   = [alpDepSetFreqData alpDepSetFreq];                     
                        end
                        alpDepSetFreqData = alpDepSetFreqData(randperm(size(alpDepSetFreqData,2)));
                    end
                    
%                     t_type         = trialtype(1,trialNo);
                    if trialNo > 12 && t_type == 2
                         alpDepSetFreqData  = alpDepSetFreqData(randperm(size(alpDepSetFreqData,2)));
                         setfreqtouse       = alpDepSetFreqData(1:runtimeDurationS);
                    end
                    
                else
                    EXPcount = EXPcount+1; 
                end
                
                if(trialNo == (end_value+1))
                    disp('Session is succesfully completed');
                    state = 0; % Run back to the default state
                end
                
        elseif state == 5 % Exit the Experiment
            rda_close(sock);
            save(['Alphacontrol_' tag]);
            clear all;
            break
        
        elseif state == 6 % Load the data and perform the analysis
            
            try
                dataToAnalyse = load(['BF_' tag ],'-mat');
                subdata = dataToAnalyse.subdata;
            catch
                disp('The file is not in the current folder or in the matlab search path');
                disp('Try loading the file manually');
                [FileName,PathName] = uigetfile('*.mat','Select the MATLAB data file');
                filetoanalyse       = fullfile(PathName,FileName);
                dataToAnalyse       = load(filetoanalyse);
                subdata = dataToAnalyse.subdata;          
            end
            
            change_alphapower_time(handles,subdata);
            change_alphapower_trials(handles,subdata);
            state = 0; % Back to the initial stage
            
        elseif state == 7 % clear all the plots
            handlestoclear = [
                    handles.changeAlphaTime   
                    handles.changeAlphaTrial    
                    handles.SessionSummary     
                    handles.ConsChAlpTime      
                    handles.DepChAlpTime        
                    handles.IndChAlpTime    
                    handles.ConsChAlpTrials     
                    handles.DepChAlpTrials      
                    handles.IndChAlpTrials ];
            for i= 1:size(handlestoclear,1)
                cla(handlestoclear(i));
            end
            state = 0;
        end        
        drawnow;        
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    Callbacks            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       
%% Callback functions
    function Callback_Start(~,~)
        state = 1;
    end
    function Callback_Stop(~,~)
            state = 2;
    end
    function Callback_Calibrate(~,~)
            state = 3;
    end
    function Callback_Run(~,~)
            state = 4;
    end         
    function Callback_Exit(~,~)
            state = 5;
    end    
    function Callback_Analysis(~,~)
            state = 6;
    end    
    function Callback_ClearPlots(~,~)
            state = 7; 
    end
end



