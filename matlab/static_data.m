%% DATA

% v_static_reads
% holds all the readings for the positions
% T ; B ; H+ - H- ; V+ ; V-
% which are measuring gravity.
v_static_reads =    [1.78   1.81    2.11
                     1.79   1.81    0.53
                     1.80   2.61    1.27
                     1.80   0.98    1.30
                     2.58   1.86    1.26
                     1.02   1.80    1.29];

% expected_g
% the expected gravity values for each of the
% v_static reads. Columns are coupled between both matrixes
expected_g =    [0	0	1 
                 0  0   -1
                 0  1   0 
                 0  -1  0
                 1  0   0 
                 -1 0   0];
                