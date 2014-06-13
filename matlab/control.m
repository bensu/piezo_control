%% First Attempt to Control


clear acc
clear t

total_t = 20;
actuate_t = 10;

%% Arrays
T = 0.01;
N = total_t / T + 12;
t = zeros(N,1);
t_act = zeros(N,1);
acc = zeros(N,1);
act = zeros(N,1);
g  = zeros(size(t));
gf = zeros(size(t));
v  = zeros(size(t));
x  = zeros(size(t));
vf = zeros(size(t));
xf = zeros(size(t));
K = 1000;

enable_pin  = 10;
dir_pin     = 7;

f = 3;      % [Hz]
prev = 0;

%% Filters
alpha_low = 0.2;
lp = @(y,x) (alpha_low*y + (1-alpha_low)*x);
alpha_high = 0.1;
hp = @(y,x_1,x_2) ((1-alpha_high)*y + (1-alpha_high)*(x_1 - x_2));

%% Start
a.analogWrite(enable_pin,230);
a.digitalWrite(dir_pin,0);

cut_off = [5e-4 5e-3 0.2]; % [xf vf gf]

%% Controller
k = -1e2;
z = -0.999;
p = -0.8607;

Kx = -1e4;
Kv = 6e3;
Kg = -150;
l = 0.1;
n_samples = 10;
i = n_samples + 1;
tic
elapsed_time = toc;
while (elapsed_time < total_t)
    elapsed_time = toc;
    if (prev + T < elapsed_time) || abs(prev + T - elapsed_time) < 1e-5
        t(i) = elapsed_time;
        acc(i) = a.analogRead(2);
        g(i)   = n_to_g(3,mean(acc(i-n_samples:i)));
        prev = elapsed_time;
        %% Signal Processing
        % a(t) filtering
        gf(i) = hp(gf(i-1),g(i),g(i-1));
%         gf(i) = lp(gf(i-1),gf(i));
        v(i) = v(i-1) + (t(i)-t(i-1))*gf(i-1); % a(t) integral to v(t)
        % v(t) filtering
        vf(i) = hp(vf(i-1),v(i),v(i-1));
%         vf(i) = lp(vf(i-1),vf(i));
        x(i) = x(i-1) + (t(i)-t(i-1))*vf(i-1); % v(t) integral to x(t)
        % x(t) filtering
        xf(i) = hp(xf(i-1),x(i),x(i-1));
%         xf(i) = lp(xf(i-1),xf(i));
        
%         if false
%         if any(abs([xf(i) vf(i) gf(i)]) > cut_off) && i > n_samples*4
        if abs(vf(i)) > cut_off(2) && i > n_samples*4
%             abs([xf(i) vf(i) gf(i)]) > cut_off
% %             act(i) = -p*act(i-1) + k*(gf(i) + z*gf(i-1));
            act(i) = -Kv*(vf(i)-sign(vf(i))*cut_off(2));
            [n,dir] = V_to_N(act(i));
            a.roundTrip(dir,n);
        end
        t_act(i) = toc;
        i = i + 1;
    end
end


a.analogWrite(enable_pin,0);
a.digitalWrite(dir_pin,0);

%%

index_values = (t ~= 0);
t   = t(index_values);
t_act = t_act(index_values);
acc = acc(index_values);
act = act(index_values);
g = g(index_values);
v = v(index_values);
x = x(index_values);
%%
gf = gf(index_values);
vf = vf(index_values);
xf = xf(index_values);

first_noise = find_noise(cut_off(3),10,g);
tn = t(first_noise);
last_actuate = t(find(act,1,'last'));

%%
normalize = @(gf,x) (rms(gf)*x/rms(x));
figure
hax = axes;
hold on
% plot(t,normalize(vf,acc-mean(acc)),'r')
% plot(t,g,'k')
% plot(t,gf)
% plot(t,normalize(acc-mean(acc)),'k')
% plot(t,normalize(vf,vf),'k')

plot(t,vf,'k')
% plot(t_act,normalize(vf,act),'k')
% plot(t,act,'r')
% plot(t,normalize(vf,xf),'g')
% plot(t,xf,'g')
num = 2;
line(get(hax,'XLim'),[cut_off(num) cut_off(num)])
line(get(hax,'XLim'),-[cut_off(num) cut_off(num)])
grid on
hold off