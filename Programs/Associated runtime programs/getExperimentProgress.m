% This program is used to find the progress made in the experiment
function [nextSessionNum,nextTrialNum,sessionNumList,trialNumList] = getExperimentProgress(subjectName,folderName)

if ~exist('folderName','var')
    pathStr = fileparts(pwd);
    folderName = fullfile(pathStr,'Data',subjectName);
end

allFiles = dir(folderName);

matchingString = [subjectName 'RawData'];
matchingStringLength = length(matchingString);

sessionNumList=[]; trialNumList=[];
for i=1:length(allFiles)
    name = allFiles(i).name;
    if strncmp(name,matchingString,matchingStringLength)
        p1=strfind(name,'Session');
        p2=strfind(name,'Trial');
        p3=strfind(name,'.mat');
        sessionNumList = cat(2,sessionNumList,str2double(name(p1+7:p2-1)));
        trialNumList = cat(2,trialNumList,str2double(name(p2+5:p3-1)));
    end
end

if isempty(sessionNumList)
    nextSessionNum=1; 
    nextTrialNum=1;
else
    maxSessionNum=max(sessionNumList);
    maxTrialNum=max(trialNumList(sessionNumList==maxSessionNum));
    trialTypeFileName = fullfile(folderName,[subjectName 'trialTypeList.mat']);
    load(trialTypeFileName);
    [nextSessionNum,nextTrialNum] = getNextTrialAndSession(trialTypeList,maxSessionNum,maxTrialNum);
end