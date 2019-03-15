%% Defining parameters:
c = [ones(1,5), zeros(1,5)]; % defining a vector of zeros and ones
b = randperm(size(c,2));     % creating randomize array positions
a = c(b);       

[First_catTrialPos,Second_catTrialPos, Third_catTrialPos] = separateTrialPos(a);
% First:  Trials preceded  by valid(1) trials.
% Second: Trials preceded by invalid or constant(0) trial types.
% Third:  Trials preceeded by more than one valid trials.


