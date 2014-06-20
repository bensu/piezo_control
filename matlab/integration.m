%% Integration
% gf = custom_filter(g);
% v  = cumtrapz(t,gf);
% vf = custom_filter(v);
% x  = cumtrapz(t,vf);
% xf = custom_filter(x);

%% Hand Integration for Real Time
b_order = 5;
[B,A] = butter(b_order,0.5/25,'high');


f = @(b,a,y,x,i) (dot(b,x(i:-1:(i-length(b)+1))) ...
            - dot(a(2:end),y((i-1):-1:(i-length(a)+1))))/a(1);
a_l = 0.99;
% lp = @(y,x,i) (alpha_low*y(i) + (1-alpha_low)*x(i));
lp = @(y,x,i) f(1-a_l,a_l,y,x,i);
a_h = 0.96;
hp = @(y,x,i) f([a_h -a_h],[1 -a_h],y,x,i);
% hp = @(y,x,i) f(B,A,y,x,i);
d = @(x,x2) -(x-x2);

nm = @(y,x) (rms(y)*x/rms(x));
phase = @(x,y) ((180/pi)*acos(dot(x,y) ./ (norm(x)*norm(y))));

gf = zeros(size(t));
v  = zeros(size(t));
x  = zeros(size(t));
vf = zeros(size(t));
xf = zeros(size(t));

for i = b_order+1:length(t)
    gf(i) = hp(gf,g,i);
    v(i) = v(i-1) + (t(i)-t(i-1))*(gf(i)+gf(i-1))/2;
%     v(i) = d(g(i),g(i-1));
    vf(i) = hp(vf,v,i);
    x(i) = x(i-1) + (t(i)-t(i-1))*(vf(i)+vf(i-1))/2;
    xf(i) = hp(xf,x,i);
%     xf(i) = lp(xf(i-1),x(i));
end

% delay_samples = 1;
% B = [zeros(1,delay_samples) 1];
% gf = filter(B,1,gf);
% vf = filter(B,1,vf);
% xf = filter(B,1,xf);

%%
s_g = g-mean(g);
phase(s_g,gf)
phase(s_g,vf)
phase(s_g,xf)


%%
hold on
grid on
plot(t,s_g)
plot(t,nm(s_g,gf),'g')
plot(t,nm(s_g,vf),'k')
plot(t,nm(s_g,xf),'r')
hold off