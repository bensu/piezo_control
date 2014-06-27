%% G_MAX 
% Objective: determine what is the maximum acceleration (g_max) the 
% actuator is can produce in the system.
% g_max will later be used to vibrate the system

%% Run Duration
actuate_t = 10;
T = 0.03;

%% Signal
f = 2.962;   % [Hz]
A = 150;     % [V]
damping =  0.0096;

%% Start loop
% G_MAX 0.85
g_max = 0.5;
[t,acc,u] = Run.sine_wave(a,actuate_t,2,T,A,f);

% f_stop = @(k,t,a) true;
% f_u    = @(k,t,a) (t < actuate_t)*A*sin(2*pi*f*t);
% [t,acc] = Run.loop(a,total_t,T,k_init,f_stop,f_u)

%% Plot
g = Arduino.n_to_g(3,acc);
g = g - mean(g);

ss_index = t > 5;
t_ss = t(ss_index);
g_ss = g(ss_index);
RMS = rms(g_ss);
C = sqrt(2)*RMS;
bk = -2*damping*C/A;
ns = Run.expand(t,acc,u);
[t,acc,u] = ns{1:3};
% g_max = 0.8;
figure
hax = axes;
hold on
grid on
plot(t,g,'k')
line(get(hax,'XLim'),[C C])
line(get(hax,'XLim'),-[C C])
hold off
