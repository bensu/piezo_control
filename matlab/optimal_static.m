%% Optimal Control

%% First Attempt to Control

clear run
clear con

total_t = 20;
T = 0.03;

%% Controller Object
% System*
omega = 2*pi*2.962;
damping = 0.0096;
bk = 1.25e-4;
ds = Controller.second_order_system(T,omega,damping,bk);
% Optimal Gain

Q = 1e8*eye(size(ds.A));
R = 1;
S = eye(size(ds.A));

[K,P_static,e] = dlqr(ds.A,ds.B,Q,R,0);

K

%%
N = size(ds.A,1);
N_it = 1000;
P = zeros(N,N,N_it);

% Indexing in P is reversed at first
% P(:,:,1) = S;
% G  = ds.A;
% H  = ds.B;
% Gt = G';
% Ht = H';
% tol = 1e-3;
% i = 2;
% error = 2;
% while (error > tol) && (i < N_it) || (i < 5)
%     Pi = P(:,:,i);
%     P(:,:,i+1) = Q + Gt*Pi*G-Gt*Pi*H*((R + Ht*Pi*H) \ (Ht*Pi*G));
%     error = norm(P(:,:,i+1)- P_static);
%     i = i + 1;
% end
% 
% P = P(:,:,1:i-1);       % Trim
% P = P(:,:,end:-1:1);    % Reverse
% Kk = zeros(size(P,3),N);
% for i = 1:size(P,3)
%     Kk(i,:) = inv(R)*Ht*inv(Gt)*(P(:,:,i) -Q);
% end

%     Kk(i,:) = inv(R)*Ht*inv(Gt)*(P(:,:,i+1) -Q);

i



% 
% Kx = 0;
% Kv = -9e3;
% Kg = 0;
% K = [Kx Kv Kg];
% cut_off = [2e-4 4e-3 6e-2]; % [x v g]
% con = Controller(ds,cut_off,K);
% 
% %% Observer
% Q = 1;
% R = 0.5;
% tol = 1e-8;
% con = con.find_Mn(Q,R,tol);
% 
% %% Profiling
% % read_time    = zeros(N,1);
% % process_time = zeros(N,1);
% % actuate_time = zeros(N,1);
% 
% % run = Run.control_run(a,total_t,T,0.5,con)
% 
% % run.store('Viscous/1e3/');
% %%
% 
% % run.plot(3,[5 3])
% DSP.plot_exp(run.T,run.t,run.g)
% 
% %%
% index = 2;
% % run.plot_cutoff(index,cut_off(index))
% %%
% 
% [X,f] = DSP.get_fft(T,run.g);
% f_damped = DSP.damped_f(X,f,1);
% % DSP.plot_spectrum(T,run.g)
% 
% format long
% damping = DSP.get_damping(run.T,run.t,run.g)
% rms(run.g)
% %r = DSP.nm_rms(run.g)
% 
% % DSP.plot_exp(run.T,run.t,run.g)
