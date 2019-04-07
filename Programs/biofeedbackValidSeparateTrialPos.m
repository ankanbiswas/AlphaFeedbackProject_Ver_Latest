% Test code written by Ankan Biswas.
% Purpose, given a trial sequence which consist of two different trial types
% It would separate out the positions of those trialtypes

function [First_catTrialPos,Second_catTrialPos, Third_catTrialPos] = biofeedbackValidSeparateTrialPos(a,d)
    % Input 1: Takes arrays containing 1's and 0's 
    % Input 2: Display Flag
    % Output: Positions of the trialtypes defined
 aFrom12 = a;
 a = a(2:49);
%% Defining parameters
% c = [ones(1,5), zeros(1,5)]; % defining a vector of zeros and ones
% b = randperm(size(c,2));     % creating randomize array positions
% a = c(b);                    % shuffing a vector according to randomize positions

% a = [1 0 1 1 0 0 1 0 1 1 0 1 0 1 1 1];
% a = [0 0 1 0  0 1 1 1 0 0 1 0 0];

% Defining trialtypes:
% First:  Trials preceded  by valid(1) trials
% Second: Trials preceded by invalid or constant(0) trial types.
% Third:  Trials preceeded by more than one valid trials

First_catTrialPos  = [];     % defining the first catagory of trialpositions
Second_catTrialPos = [];     % defining the second catagory of trialpositions
Third_catTrialPos  = [];     % defining the third catagory of trialpositions

%% following code section would take each valid trials preceeded by a valid trial

for i= 2:length(a)
    tempTrialPos=i;

    if a(tempTrialPos) == 1
        if a(tempTrialPos-1) == 1
            % taking all the trails positions which has a preceeding
            % 1(valid trials)
            First_catTrialPos = [First_catTrialPos,tempTrialPos];
        elseif a(tempTrialPos-1) == 0
            % taking all the trails positions which has a preceeding
            % 0(constant or invalid trials)
            Second_catTrialPos = [Second_catTrialPos,tempTrialPos];
        end
    end
end

Fourth_catTrialPos =  First_catTrialPos(1);
rev_firstTrials = fliplr(First_catTrialPos);
for i = 1:(length(rev_firstTrials)-1)
    if (rev_firstTrials(i)-rev_firstTrials(i+1))>1
        temp_Fourth_catTrialPos = rev_firstTrials(i);
        Fourth_catTrialPos = [Fourth_catTrialPos temp_Fourth_catTrialPos];
    end
end

Pos_FourthTrial = [];
for i= 1:length(Fourth_catTrialPos)
    tempElement = Fourth_catTrialPos(i);
    tempPositions = find(First_catTrialPos==tempElement);
    Pos_FourthTrial = [Pos_FourthTrial tempPositions];
end
    
Fifth_catTrialPos = First_catTrialPos;
Fifth_catTrialPos(Pos_FourthTrial)=[];


%% Following code section would take (one) valid trials in case it is preceeded by a Multiple valid trial

% for i= 1:(length(a))
%     tempTrialPos=i;
%     if i<length(a)
%         diff = a(tempTrialPos)- a(tempTrialPos+1);
%         if i>1   
%             revDiff = a(tempTrialPos)- a(tempTrialPos-1);
%         end; 
%     else
%         revDiff = a(tempTrialPos)- a(tempTrialPos-1);
%     end
%     
%     if i<length(a) &&  i>1 && diff==1 && revDiff==0
%         Third_catTrialPos = [Third_catTrialPos,tempTrialPos];
%     elseif i==length(a)
%         if revDiff==0 && a(i)==1
%             Third_catTrialPos = [Third_catTrialPos,tempTrialPos];
%         end
%     end
% end
First_catTrialPos = sort(Fourth_catTrialPos);
Third_catTrialPos = sort(Fifth_catTrialPos);

if a(1) == 1
   if aFrom12 == 0
       Second_catTrialPos = [Second_catTrialPos,1];
   else
       if a(2)==0
           First_catTrialPos = [First_catTrialPos, 1];
        else
           First_catTrialPos(First_catTrialPos==2) = [];
           Third_catTrialPos = [Third_catTrialPo,2];
           Third_catTrialPos = sort(Third_catTrialPos);
       end
   end
end


%% Display the result if the flag is "ON": 
if d==1
    disp(a);
    disp(First_catTrialPos); disp(Second_catTrialPos); disp(Third_catTrialPos);
end