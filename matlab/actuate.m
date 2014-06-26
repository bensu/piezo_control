%% G_MAX 
% Objective: determine what is the maximum acceleration (g_max) the 
% actuator is can produce in the system.
% g_max will later be used to vibrate the system

%% Run Duration
actuate_t = 10;
T = 0.03;

%% Signal
f = 2.962;   % [Hz]
A = 150;    % [V]

%% Start loop
% G_MAX 0.85
g_max = 0.5;
[t,acc,u] = Run.sine_wave(a,actuate_t,g_max,T,A,f);

%% Plot

ns = Run.expand(t,acc,u);
[t,acc,u] = ns{1:3};
% g_max = 0.8;
figure
hax = axes;
hold on
plot(t,Arduino.n_to_g(3,acc),'k')
line(get(hax,'XLim'),[g_max g_max])
hold off
