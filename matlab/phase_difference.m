% function d_phase = phase_difference(x,y)
% d_phase = phase_difference(x,y)
% Measures the phase difference between two signals in ???

omega = 1;
T = 0.01;
N = 10*floor(2*pi/T);
n = 0:N;
t = n*T;
x = sin(omega*t);
y = sin(omega*t + pi);

phase = @(x,y) (acos(dot(x,y) ./ (dot(x,x)*dot(y,y))));

hold on
plot(t,x)
plot(t,env)
hold off
% end