

t = run.t;
x = run.g;

[pks,loc] = findpeaks(x);

hold on
plot(t(loc),pks)
plot(t,DSP.envelope(x))
hold off

%%
model = fit(t,env, 'exp1');
k = model.a;
tau = -1/model.b;