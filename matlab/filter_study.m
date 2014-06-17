%% 
% I have g, t and acc

%% Helper Function
hp  = @(a,x) filter([1-a a-1],[1 a-1], x);
lp  = @(a,x) filter(a,[1 a-1],x);
it = @(T,x) filter([0 T],1,x);
ct  = @(t,x) cumtrapz(t,x);

nm = @(y,x) (rms(y)*x/rms(x));
phase = @(x,y) ((180/pi)*acos(dot(x,y) ./ (norm(x)*norm(y))));

%%
N = 1000;
alpha = linspace(0,0.5,N)';
phi = zeros(N,1);
error = zeros(N,1);
T = 0.01;
for i = 1:N
    a = alpha(i);
    g_dc = lp(a,g);
    gf = g - g_dc;
    v  = ct(t,gf);
    v_dc = lp(a,v);
    vf = v - v_dc;
    x = ct(t,vf);
    x_dc = lp(a,x);
    xf = x - x_dc;
%     gf = hp(a,g);
%     v = ct(t,gf);
%     vf = hp(a,v);
%     x  = it(T,vf);
%     xf = hp(a,v);
    phi(i) = phase(g-mean(g),vf);
    error(i) = mean(x)/max(x);
end

%%

[~,l] = min(error);
a = alpha(l);
a = 0.01;

    g_dc = lp(a,g);
    gf = hp(a,g - g_dc);
    v  = ct(t,gf);
    v_dc = lp(a,v);
    vf = hp(a,v - v_dc);
    x = ct(t,vf);
    x_dc = lp(a,x);
    xf = hp(a,x - x_dc);

%%


%%
hold on
grid on
plot(alpha,phi)
plot(alpha,nm(phi,error),'k')
% plot(t,gf)
% plot(t,g)
% plot(t,gf)
% plot(t,g-mean(g))
% plot(t,nm(g,vf),'k')

hold off