%% Defining parameters
c = [ones(1,5), zeros(1,5)]; % defining a vector of zeros and ones
b = randperm(size(c,2));     % creating randomize array positions
a = c(b);              