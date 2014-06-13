%% Filter Design

%% Loading Variables
% load('acc_static')
% g = n_to_g(3,acc(:,3));
% t = (0:T:(T*(length(g)-1)))';

%% Low - Pass Filter
a_lp = 0.8;
g_lp = filter(a_lp, [1 a_lp-1], g);

%% Moving Average
n_samples = 6;
A = 1;
b = ones(n_samples,1)/n_samples;

v = filter(b,A,g);
x = filter(b,A,v);
hold on
grid on
subplot(2,1,1)
plot(t,x,'k')
subplot(2,1,2)
plot(t,g,'b')
hold off
%% System

% A = [1 T T^2/2; 0 1 T; 0 0 1]; % State prediction
% B = zeros(size(A,1),1);
% C = [0 0 0; 0 0 0; 0 0 1]; % Measurement matrix
% 
% plant = ss(A,B,C,0,T,'inputname',{'a'}, 'outputname', 'y');
% Q = 0.5;
% R = 0.5;
% [kalmf,L,P,M] = kalman(plant,Q,R);
% [Y,T,X] = lsim(kalmf,g,t) 