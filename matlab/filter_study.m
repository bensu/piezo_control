%% Try DSP.PID

total_t = 20;
T = 0.03;

%% Controller Object
% System
f_natural = 2.962;
omega = 2*pi*f_natural;
damping = 0.0096;
bk = -1.25e-4;

%% Gain

Kp = 10;
Ti = 1;
Td = 1;
Nd = 2;
[num,den] = tfdata(pidstd(Kp,Ti,Td,Nd,T));
B = num{1};   % Unpack cells
A = den{1};

f = @(t) exp(-t*damping*omega).*sin(omega*t);

t = (0:T:20)';
N = length(t);
g = f(t);

u = zeros(N,1);
uu = u;

%% Loop
n_samples = max(length(A),length(B));
for k = length(B):N
    uu(k) = DSP.real_filter(B,A,k,g,uu);
end

hold on
plot(t,uu)
plot(t,u,'r')
hold off
