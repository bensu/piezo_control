%a = arduino('/dev/ttyS101');
%sudo ln -s /dev/ttyACM0 /dev/ttyS101 
% Connect pins


clear acc
clear t
prev = 0;
total_time = 15;    % [s]
T = 0.01;           % [s]
N = total_time / T;
t = zeros(N,1);
acc = zeros(N,1);

%% Start
a.analogWrite(enable_pin,0);
a.digitalWrite(dir_pin,0);
i = 1;
tic
elapsed_time = toc;
while (elapsed_time < total_time)
    elapsed_time = toc;
    if (prev + T < elapsed_time) || abs(prev + T - elapsed_time) < 1e-5
        t(i) = elapsed_time;
        acc(i) = a.analogRead(2);
        prev = elapsed_time;
        i = i + 1;
    end
end

a.analogWrite(enable_pin,0);
a.digitalWrite(dir_pin,0);

%%

index_values = (t ~= 0);
t   = t(index_values);
acc = acc(index_values);
g = n_to_g(3,acc);

%% Hand Integration for Real Time

alpha_low = 0.1;
lp = @(y,x) (alpha_low*y + (1-alpha_low)*x);
alpha_high = 0.1;
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
    v(i) = v(i-1) + (t(i)-t(i-1))*gf(i-1);
    % v(t) filtering
    vf(i) = hp(vf(i-1),v(i),v(i-1));
    vf(i) = lp(vf(i-1),vf(i));
    % v(t) integral to x(t)
    x(i) = x(i-1) + (t(i)-t(i-1))*vf(i-1);
    % v(t) filtering
    xf(i) = hp(xf(i-1),x(i),x(i-1));
    xf(i) = lp(xf(i-1),xf(i));
end

%%
cut_off_g = 0.1;
first_noise = find_noise(cut_off_g,10,gf);
tn = t(first_noise);
%%
hold on
plot(t,gf)
plot(t,rms(gf)*vf/rms(vf),'k')
plot(t,rms(gf)*xf/rms(xf),'r')
hold off
