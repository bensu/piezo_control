%% Slowest PWM frequency

f = 16e6/(1024*256);

%% Resistor Calculation

V = 160;
C = 150e-9;
% f = 50;
resolution = 0.1;
decay_fraction = 10;

T = 1/f;
t_decay = resolution * T;
R = t_decay / (C*log(decay_fraction))
P = V^2 / R

%% Backwards

P_max = 1;
R_new = (V^2)*C*log(decay_fraction)*f/(resolution*P_max)