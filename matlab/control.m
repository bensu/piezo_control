%% First Attempt to Control

clear acc
clear t

total_t = 20;
actuate_t = 10;

%% Arrays
T = 0.02;
N = floor(total_t / T) + 30;
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

%% Profiling

read_time    = zeros(size(t));
process_time = zeros(size(t));
actuate_time = zeros(size(t));

%%

enable_pin  = 10;
dir_pin     = 7;

f = 3;      % [Hz]
prev = 0;

%% Filters
alpha_low = 0.2;
lp = @(y,x) (alpha_low*y + (1-alpha_low)*x);
alpha_high = 0.1;
hp = @(y,x_1,x_2) ((1-alpha_high)*y + (1-alpha_high)*(x_1 - x_2));
d  = @(x,x2) -(x-x2);

%% Start
a.roundTrip(0,0);

cut_off = [0.15 0.15 0.15]; % [xf vf gf]
g_cut_off = 0.1;

%% Controller
k = -1e2;
z = -0.999;
p = -0.8607;
delta_time = 5;
Kx = 0;
Kv = 7e0;
Kg = 0;
l  = 0.1;
n_samples = 2;
i = n_samples + 1;
tic
elapsed_time = toc;
while (elapsed_time < total_t)
    elapsed_time = toc;
    if (prev + T < elapsed_time) || abs(prev + T - elapsed_time) < 1e-4
        t(i) = elapsed_time;
        acc(i) = a.sample();
        read_time(i) = toc - elapsed_time;
        g(i)   = n_to_g(3,acc(i));
        prev = elapsed_time;
        %% Signal Processing
        v(i) = d(g(i),g(i-1));
        vf(i) = lp(vf(i-1),v(i));
        x(i) = -g(i);
        if any(abs([x(i) vf(i) g(i)]) > cut_off) && false
%             process_time(i) = toc - elapsed_time - read_time(i);
            act(i) = -[Kx Kv Kg]*[x(i) vf(i) g(i)]';
            [n,dir] = V_to_N(act(i));
            a.roundTrip(dir,n);
%             actuate_time(i) = toc - elapsed_time - read_time(i) - process_time(i);
%             t_act(i) = toc;
        end
        if elapsed_time > delta_time && elapsed_time < 2*delta_time
            a.roundTrip(0,245);
        end
        if elapsed_time > 2*delta_time
%            a.roundTrip(1,0);
        end
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
s = n_to_g(3,acc);
max_val = max(abs(s));
RMS     = rms(s);
rms(s)/max_val^2;

%%
phase = @(x,y) ((180/pi)*acos(dot(x,y) ./ (norm(x)*norm(y))));

phase(acc-mean(acc),vf)
%%
normalize = @(gf,x) (rms(gf)*x/rms(x));
figure
hax = axes;
hold on
plot(t,acc)
% plot(t,normalize(g,acc-mean(acc)),'r')
% plot(t,g)
% plot(t,gf)

% plot(t,normalize(g,v-mean(v)),'k')
% plot(t,normalize(g,v),'r')
% plot(t,vf,'k')

% plot(t,normalize(g,act),'k')
% plot(t,act,'r')
% plot(t,normalize(g,-(x-mean(x))),'g')
% plot(t,normalize(g,x),'g')
% plot(t,x,'g')
num = 3;
% line(get(hax,'XLim'),[cut_off(num) cut_off(num)])
% line(get(hax,'XLim'),-[cut_off(num) cut_off(num)])
grid on
hold off