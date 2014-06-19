%% Integration
% gf = custom_filter(g);
% v  = cumtrapz(t,gf);
% vf = custom_filter(v);
% x  = cumtrapz(t,vf);
% xf = custom_filter(x);

%% Hand Integration for Real Time

alpha_low = 0.9;
lp = @(y,x) (alpha_low*y + (1-alpha_low)*x);
alpha_high = 0.1;
hp = @(y,x_1,x_2) ((1-alpha_high)*y + (1-alpha_high)*(x_1 - x_2));
d = @(x,x2) -(x-x2);
gf = zeros(size(t));
v  = zeros(size(t));
x  = zeros(size(t));
vf = zeros(size(t));
xf = zeros(size(t));

for i = 2:length(t)
    gf(i) = lp(gf(i),g(i),g(i-1));
    v(i) = v(i-1) + (t(i)-t(i-1))*(g(i)+g(i-1))/2;
%     v(i) = d(g(i),g(i-1));
    vf(i) = hp(vf(i-1),v(i),v(i-1));
    x(i) = -gf(i);
%     x(i) = x(i-1) + (t(i)-t(i-1))*(vf(i)+vf(i-1))/2;
%     xf(i) = hp(xf(i-1),x(i),x(i-1));
%     xf(i) = lp(xf(i-1),x(i));
end

%%
s_g = g-mean(g);
hold on
grid on
plot(t,s_g)
% plot(t,rms(s_g)*g/rms(gf),'k')
plot(t,rms(s_g)*vf/rms(vf),'k')
plot(t,rms(s_g)*x/rms(x),'r')
hold off