%% High pass filter

% H = @(T,a,w) a*(exp(1j*w*T)-1)/(exp(1j*w*T)-a);
% G = @(T,a,w) abs(H(T,a,w));
% P = @(T,a,w) angle(H(T,a,w));

[z,p,k] = butter(3,0.5/40,'high');
sos = zp2sos(z,p,k);
fvtool(sos,'Analysis','freq')


%%
f_beam = 3;
f_noise = 0.5;
T = 0.01;
N = 1000;
alpha = linspace(0,1,N);
FR = zeros(N,1);
FR5 = zeros(N,1);
f = W/pi/T;
[~,l] = min(abs(f-f_beam));
[~,k] = min(abs(f-f_noise));

for i = 1:N
    a = alpha(i);
    H = freqz(a*[1 -1],[1 -a],N);
    FR(i) = H(l);
    FR5(i) = H(k);
end

%% Plot Response
a = 0.95;
H = freqz(a*[1 -1],[1 -a],N);
subplot(2,1,1)
hold on
plot(f,abs(H))
plot(f(l),abs(H(l)),'o');
hold off
subplot(2,1,2)
hold on
plot(f,angle(H)*180/pi);
plot(f(l),angle(H(l))*180/pi,'o');
hold off
%% Plot
n_plots = 2;
subplot(n_plots,1,2)
hold on
phi = 180*angle(FR)/pi;
[~,kk] = min(abs(phi - 20));
plot(alpha,phi)
plot(alpha(kk),phi(kk),'o')
hold off
subplot(n_plots,1,1)
hold on
M = abs(FR)./abs(FR5);
plot(alpha,M);
plot(alpha(kk),M(kk),'o')
hold off
% subplot(3,1,3)
% plot(alpha,abs(FR5));
