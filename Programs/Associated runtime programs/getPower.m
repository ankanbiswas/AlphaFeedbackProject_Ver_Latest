function [meanPower,freq] = getPower(rawData,Fs,maxFrequencyHz)

% setting parameters for the chronux toolbox function mtspectrumc for analysing power spectrum of the signal
params.tapers = [1 1]; % tapers [TW,K], K=<2TW-1
params.pad = -1; % no padding
params.Fs = Fs; % sampling frequency
params.trialave = 1; % average over trials
params.fpass = [0 maxFrequencyHz]; 

[meanPower,freq] = mtspectrumc(rawData',params);
end