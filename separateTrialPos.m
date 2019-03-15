% Test code written by Ankan Biswas.
% Purpose, given a trial sequence which consist of two different trial types
% It would separate out the positions of those trialtypes

function [First_catTrialPos,Second_catTrialPos, Third_catTrialPos] = separateTrialPos(a)
    % Input: Takes arrays containing 1's and 0's 
    % Output: Positions of the trialtypes defined
    
    
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


%% Following code section would take (one) valid trials in case it is preceeded by a Multiple valid trial

for i= 1:(length(a))
    tempTrialPos=i;
    if i<length(a)
        diff = a(tempTrialPos)- a(tempTrialPos+1);
        if i>1   
            revDiff = a(tempTrialPos)- a(tempTrialPos-1);
        end; 
    else
        revDiff = a(tempTrialPos)- a(tempTrialPos-1);
    end
    
    if i<length(a) &&  i>1 && diff==1 && revDiff==0
        Third_catTrialPos = [Third_catTrialPos,tempTrialPos];
    elseif i==length(a)
        if revDiff==0 && a(i)==1
            Third_catTrialPos = [Third_catTrialPos,tempTrialPos];
        end
    end
end

%% Display the result
disp(a);
disp(First_catTrialPos); disp(Second_catTrialPos); disp(Third_catTrialPos);