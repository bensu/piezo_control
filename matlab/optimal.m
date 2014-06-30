%% Analyze runs with optimal control

R = @(run) rms(run.g-mean(run.g));
T = @(run) DSP.fit_exp(run.t,run.g);
K = @(run) run.control.K(1);

arg_list = {R,T,K};
directory = 'db/OptimalStatic/';

d2 = [directory,'SecondSweep/'];
file_list = dir([d2,'*.mat']);
out = Run.map(d2,T,R,K);

%%
f   = @(i) [out{i,:}]';
tau = f(1);
RMS = f(2);
KK  = f(3);

[~,l] = min(tau);

% space = load([d2,file_list(l).name]);
% runC = space.run;
% 
% space = load('/home/carlos/sketchbook/piezo/matlab/db/Damping/2014-06-26 16h12m05s.mat');
% runU = space.run;
% 
% figure
% Run.compare_runs(runU,runC)

% DSP.plot_exp(run.T,run.t,run.g)



tol = 1e-3;
near = @(y,x) abs((x - y)/x) < tol;
x = 1./(tau*2*pi*3);

Ku = unique(KK/30.151858522408720);
n_points = length(Ku);
m = zeros(n_points,1);
s = zeros(n_points,1);
for i = 1:n_points
    aux = x(near(KK/30.151858522408720,Ku(i)));
    m(i) = mean(aux);
    s(i) = std(aux);
end

%%

plot(-Ku,m,'o')