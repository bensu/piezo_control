%% Integration
% gf = custom_filter(g);
% v  = cumtrapz(t,gf);
% vf = custom_filter(v);
% x  = cumtrapz(t,vf);
% xf = custom_filter(x);

%% Hand Integration for Real Time

alpha_low = 0.1;
lp = @(y,x) (alpha_low*y + (1-alpha_low)*x);
alpha_high = 0.95;
hp = @(y,x_1,x_2) ((1-alpha_high)*y + (1-alpha_high)*(x_1 - x_2));

gf = zeros(size(t));
v  = zeros(size(t));
x  = zeros(size(t));
vf = zeros(size(t));
xf = zeros(size(t));

for i = 2:length(t)
    % a(t) filtering
    gf(i) = hp(gf(i-1),g(i),g(i-1));
    gf(i) = lp(gf(i-1),gf(i));
    % a(t) integral to v(t)
    v(i) = v(i-1) + (t(i)-t(i-1))*g(i-1);
    % v(t) filtering
    vf(i) = hp(vf(i-1),v(i),v(i-1));
    vf(i) = lp(vf(i-1),vf(i));
    % v(t) integral to x(t)
    x(i) = x(i-1) + (t(i)-t(i-1))*v(i-1);
    % v(t) filtering
    xf(i) = hp(xf(i-1),x(i),x(i-1));
    xf(i) = lp(xf(i-1),xf(i));
end

%%
hold on
plot(t,g)
plot(t,rms(g)*v/rms(v),'k')
plot(t,rms(g)*x/rms(x),'r')
hold off