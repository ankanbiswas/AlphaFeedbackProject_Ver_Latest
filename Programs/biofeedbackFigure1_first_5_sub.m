

subjectNames = {'ABA','ARC','DD','AJ','SG',...
    'MP','PB','SSA','SL','DB', ...
    'PK','HS','AD','SB','SS',...
    'SHG','KNB','KNB','BPP','SSH',...
    'MJR','TBR','SKH','PM'}';

% numSubjects = length(subjectNames); % no of subjects for which analysis would be carried out
% numSubList = 1:5;
% numSubList = numSubList';
numSubjects = 5;

for i=1:numSubjects
    subInd = i;
    disp(subInd);
    biofeedbackFigure1(subjectNames{subInd},'');
    
end
%     flag;