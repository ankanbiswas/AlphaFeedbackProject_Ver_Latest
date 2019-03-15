subjectNames = {'ABA','ARC','DD','AJ','SG',...
                'MP','PB','SSA','SL','DB', ...
                'PK','HS','AD','SB','SKS','SS',...
                'SHG','KNB','BPP','SSH',...
                'MJR','TBR','SKH','PM'}';

numSubjects = length(subjectNames); % no of subjects for which analysis would be carried out
numSubList = 1:numSubjects;
numSubList = numSubList';


for i=1:numSubjects
    subInd = i;
    biofeedbackFigure_1_mod(subjectNames{subInd},subInd)
end