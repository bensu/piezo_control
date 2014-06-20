%% Assumes T, t, and g


% T = 0.01;
% A = [1 T T^2/2;
%      0 1 T;
%      0 0 1];
% B = [0; 0; 1];
omega = 2*pi*3;
damping = 0.014;
bk = 1;
Ac = [0 1; -omega^2 -2*damping*omega];
Bc = [0; bk];
C = [-omega^2 -2*damping*omega];
D = 0;
cs = ss(Ac,Bc,C,D);    % Continuous system
ds = c2d(cs,T,'zoh');           % Discrete system

A = ds.A;
B = ds.B;

%% Signal
omega = 2*pi*3.08;
damping = 0.0279;
tau = 1/(omega*damping);
k = 1;
N = length(t);
% t = 0:T:((N-1)*T);
offset = 0.01;
% g = k*exp(-t/tau).*cos(omega*t) + offset;
u = zeros(N,1);

%% Filter
Q = 1;
R = 0.5;
N = length(t);
P = B*Q*B';         % Initial error covariance
x = zeros(2,N);     % Initial condition on the state
ye = zeros(N,1);
ycov = zeros(N,1); 
errcov = zeros(N,1);

for i = 2:length(t)
  % Measurement update
  Mn = P*C'/(C*P*C'+R);
  x_aux = x(:,i-1) + Mn*(g(i)-C*x(:,i-1));   % x[n|n]
  P = (eye(2)-Mn*C)*P;      % P[n|n]

  ye(i) = C*x_aux;
  errcov(i) = C*P*C';

  % Time update
  x(:,i) = A*x_aux + B*u(i);        % x[n+1|n]
  P = A*P*A' + B*Q*B';     % P[n+1|n]
end

%%
ph = @(y,x) (180/pi)*(acos(dot(x,y)/norm(x)/norm(y)));
dc_out = @(x) (x-mean(x));
ph((g),(x(2,:)))
ph((g),(x(1,:)))

%%
nm = @(y,x) rms(y)*x/rms(x);
hold on
grid on
plot(t,g-mean(g))
plot(t,nm(g,x(2,:)),'k')
plot(t,nm(g,x(1,:)),'r')
hold off