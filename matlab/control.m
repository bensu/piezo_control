%% First Attempt to Control

clear acc
clear t

total_t = 20;

%% Arrays
T = 0.03;
[t,acc,x,V] = Run.prepare_run(total_t,T);
N = length(t);
g = zeros(N,1);

%% Controller Object
omega = 2*pi*3;
damping = 0.0118;
bk = 1;
con = Controller(T,omega,damping,bk);

%% Observer
Q = 1;
R = 0.5;
tol = 1e-8;
con = con.find_Mn(Q,R,tol);

%% Controller
Kx = 0;
Kv = -7e3;
Kg = 0;
K = [Kx Kv Kg];

%% Profiling
read_time    = zeros(N,1);
process_time = zeros(N,1);
actuate_time = zeros(N,1);

%% Start
a.roundTrip(0,0);

cut_off = [2e-4 4e-3 6e-2]; % [x v g]

%% Start loop
n_samples = 1;
i = n_samples + 1;

input('Press enter to start loop');

tic
prev = 0;
elapsed_time = toc;
while (elapsed_time < total_t)
    elapsed_time = toc;
    if Run.sample_time(1e-4,T,prev,elapsed_time)
        t(i)   = elapsed_time;
        acc(i) = a.sample();
        g(i)   = Arduino.n_to_g(3,acc(i));
        prev = elapsed_time;
        %% Signal Processing
        x(:,i) = con.predict(i,x(:,i-1),0,g(i));
        if any(abs([x(:,i)' g(i)]) > cut_off) && true
            V(i) = -K*[x(:,i); g(i)];
            a.piezo_actuate(V(i));
        end
        i = i + 1;
    end
end

a.roundTrip(0,0);
%%
run = Run(T,t,acc,x,V);
run.store();
%%

run.plot(3,[5 3])

%%
index = 2;
run.plot_cutoff(index,cut_off(index))
%%

[X,f] = DSP.get_fft(T,run.g);
f_damped = DSP.damped_f(X,f,1)

r = DSP.nm_rms(run.g)
damping = DSP.get_damping(run.T,run.t,run.g)
DSP.plot_exp(run.T,run.t,run.g)
