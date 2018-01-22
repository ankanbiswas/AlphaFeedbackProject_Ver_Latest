function s = sine_tone(cf, d, sf)
% Generates a sine tone
% cf: carrier frequency (Hz), usually 44.1 KHz
%  d: duration (s)
% sf: audio frequency (Hz), what you want to hear
n = cf * d;                 % number of samples
s = (1:n) / cf;             % sound data preparation
s = sin(2 * pi * sf * s);   % sinusoidal modulation
