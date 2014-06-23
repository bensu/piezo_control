%% LOAD DATA
d_samples = [0.013151 0.013701, 0.013528, 0.0131, 0.0129, 0.0132, 0.0132, ...
             0.0135, 0.0131, 0.0131];
r_samples = [0.2409, 0.1922, 0.2077, 0.2045, 0.2319, 0.2103, 0.2039, ...
             0.2211, 0.2119, 0.2279];
         
%% Characterize distribution

d_mean = mean(d_samples);
d_std  = std(d_samples);
r_mean = mean(r_samples)
r_std  = std(r_samples)

100*d_std/d_mean;

100*r_std/r_mean
