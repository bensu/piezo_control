%% First Attempt to Control

clear run
clear con

total_t = 20;
T = 0.03;

%% Controller Object
% System
omega = 2*pi*2.962;
damping = 0.0096;
bk = 1;
ds = Controller.second_order_system(T,omega,damping,bk);
% Gain
Kx = 0;
Kv = -9e3;
Kg = 0;
K = [Kx Kv Kg];
cut_off = [2e-4 4e-3 6e-2]; % [x v g]
con = Controller(ds,cut_off,K);

%% Observer
Q = 1;
R = 0.5;
tol = 1e-8;
con = con.find_Mn(Q,R,tol);

%% Profiling
% read_time    = zeros(N,1);
% process_time = zeros(N,1);
% actuate_time = zeros(N,1);

run = Run.control_run(a,total_t,T,0.5,con)

run.store('Viscous/1e3/');
%%

% run.plot(3,[5 3])
DSP.plot_exp(run.T,run.t,run.g)

%%
index = 2;
% run.plot_cutoff(index,cut_off(index))
%%

[X,f] = DSP.get_fft(T,run.g);
f_damped = DSP.damped_f(X,f,1);
% DSP.plot_spectrum(T,run.g)

format long
damping = DSP.get_damping(run.T,run.t,run.g)
rms(run.g)
%r = DSP.nm_rms(run.g)

% DSP.plot_exp(run.T,run.t,run.g)
