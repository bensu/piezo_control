directory = 'db/Viscous/';
d3 = [directory,'1e3/'];
K7 = @(run) (run.control.K(2) == -7e3);
list = Run.find(d3,K7);
D = @(run) DSP.get_damping(run.T,run.t,run.g);
out = Run.map(list,D);
d = [out{:}]';
[~,l] = max(d);

space = load(list(l).name);
runC = space.run;

runC.plot(3,[1 2 3])