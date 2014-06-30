%% Find Baseline Damping

R = @(run) rms(run.g-mean(run.g));
T = @(run) DSP.fit_exp(run.t,run.g);
K = @(run) run.control.K(2);

arg_list = {R,T,K};
directory = 'db/Viscous/';

d2 = [directory,'1e2/'];
d3 = [directory,'1e3/'];
d4 = [directory,'Automatic2/'];
d5 = [directory,'1e4/'];


out2 = Run.map(d2,T,R,K);
out3 = Run.map(d3,T,R,K);
out4 = Run.map(d4,T,R,K);
out5 = Run.map(d5,T,R,K);

%%

K7 = @(run) (run.control.K(2) == -7e3);
list = Run.find(d3,K7);



f   = @(i) [[out3{i,:}] [out4{i,:}]]'; % [out5{i,:}]]';
% f   = @(i) [out4{i,:}]';
tau   = f(1);
RMS = f(2);
KK  = f(3);

x = 1./(tau*2*pi*3);

Ku = unique(KK);
n_points = length(Ku);
m = zeros(n_points,1);
s = zeros(n_points,1);
for i = 1:n_points
    aux = x(KK==Ku(i));
    m(i) = mean(aux);
    s(i) = std(aux);
end

%%

plot(-Ku,m,'o')