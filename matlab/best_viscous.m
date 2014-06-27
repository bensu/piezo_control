

K7 = @(run) (run.control.K(2) == -7e3);
list = Run.find(d3,K7);
D = @(run) DSP.get_damping(run.T,run.t,run.g);
out = Run.map(list,D);
d = [out{:}]';
[~,l] = max(d);

space = load(list(l).name);
runC = space.run;

space = load('/home/carlos/sketchbook/piezo/matlab/db/Damping/2014-06-26 16h12m05s.mat');
runU = space.run;

figure
Run.compare_runs(runU,runC)
