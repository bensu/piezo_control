%% Store uncontrolled

u_t = t;
u_xf = xf;
u_vf = vf;
u_gf = gf;

%%

rms(u_gf)/min((u_gf))^2
rms(gf)/min((gf))^2

[min(act) max(act)]
%% Compare signals

amp_norm = @(n,x) (max(n))*x/(max(x));

hold on
grid on
plot(t,amp_norm(u_gf,gf))
plot(u_t,u_gf,'k')
hold off

%%

K_vals = [2e3 3e3 2.5e3 2.3e3 1.5e3 1.7e3 1.9e3 2.1e3];
R      = [0.16 0.2192 0.1451 0.1496 0.1725 0.1676 0.1468 0.15];
V_min  = -[144 142 128 128 75 74 115];
V_mmax = [71 103 118 76 55 67 60];

[K_vals,index] = sort(K_vals);
% plot(K_vals,R(index))