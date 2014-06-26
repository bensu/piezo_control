% 1. Connect the Arduino and load the Arduino I/O program.
% 2. Create a link between the connected port
% (ACM0, ACM1, ACM2, etc.) and ttyS101 by typing:
%       sudo ln -s /dev/ttyACM0 /dev/ttyS101 
% in the terminal.
% 
% 3. While the Arduino is connected type:
%       a = arduino('/dev/ttyS101');
% in the MATLAB REPL.
%
% Connect pins
% run reads

clear run



total_t   = 30;
actuate_t = 5;
T = 0.03;


%% Signal
f = 3.07;          % [Hz]
A = 150;    % [V]


%% Start loop

Run.sine_wave(a,actuate_t,0.55,T,A,f)
