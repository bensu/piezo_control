%% First Attempt to Control

clear run
clear con

total_t = 20;
T = 0.03;

%% Controller Object
% System
f_natural = 2.962;
omega = 2*pi*f_natural;
damping = 0.0096;
bk = -1.25e-4;
ds = Controller.second_order_system(T,omega,damping,1);
cut_off = [1e-4 2e-3 6e-2]; % [x v g]
con = Controller(ds,cut_off);

%% Gain
p = 1e8;
Q = p*eye(size(ds.A));
R = 1;
con.find_Kk(Q,R);
con.K = -7e2*con.K;

%% Observer
Qm = 1;
Rm = 0.5;
tol = 1e-8;
con = con.find_Mn(Qm,Rm,tol);

%% run

run = Run.control_run(a,total_t,T,0.5,con);

run.store('OptimalStatic/');
%%

% run.plot(3,[5 3])
DSP.plot_exp(run.T,run.t,run.g)

%%
index = 1;

% run.plot_cutoff(index,cut_off(index))
%%

[X,f] = DSP.get_fft(T,run.g);
f_damped = DSP.damped_f(X,f,1);
% DSP.plot_spectrum(T,run.g)

format long
[~,tau] = DSP.fit_exp(run.t,run.g);
damping = DSP.damping(f_natural,tau)
rms(run.g)
%r = DSP.nm_rms(run.g)

% DSP.plot_exp(run.T,run.t,run.g)
