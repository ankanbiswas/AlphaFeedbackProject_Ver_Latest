function [nextSessionNum,nextTrialNum] = getNextTrialAndSession(trialTypeList,sessionNum,trialNum)

[numSessions,numTrialsPerSession] = size(trialTypeList);

if (sessionNum==numSessions) && (trialNum==numTrialsPerSession) % Experiment is complete
    nextSessionNum=sessionNum; 
    nextTrialNum=trialNum;
    
elseif (trialNum==numTrialsPerSession) % Session is complete
    nextSessionNum=sessionNum+1; 
    nextTrialNum = 1;
else
    nextSessionNum = sessionNum; 
    nextTrialNum = trialNum+1;
end
end