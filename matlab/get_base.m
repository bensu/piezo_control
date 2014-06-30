%% Find Baseline Damping

R = @(run) rms(run.g);
D = @(run) DSP.get_damping(run.T,run.t,run.g);
K = @(run) run.control.K;

arg_list = {R,D,K};
directory = 'db/Damping/';

out = Run.map(directory,D,R,K);

d = [out{1,:}];
RMS = [out{2,:}];

disp(sprintf('Damping with mean: %d and std %d',mean(d),std(d)))
disp(sprintf('RMS with mean: %d and std %d',mean(RMS),std(RMS)))

%%

sp = load('/home/carlos/sketchbook/piezo/matlab/db/Damping/2014-06-26 16h14m58s.mat');
run = sp.run;

figure
plot(run.t,9.8*run.g)
DSP.plot_exp(run.T,run.t,9.8*run.g)
grid on
title('Baseline Case')
xlabel('t [sec]')
ylabel('a [m/s^2]');
