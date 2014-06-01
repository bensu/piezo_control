%% Velocity and Displacement Integration

space = load('acc_hard');
static_space  = load('acc_static');
acc_static  = static_space.acc;

acc = space.acc(:,3);
t = space.t;
T = space.T;

%% To [g]

zero_g = mean(acc_static(:,3));   % Value the ADC takes for 0g
max_n = max(acc_static(:,3));
min_n = min(acc_static(:,3));
n_delta = max_n - min_n;        % Error size in ADC.

one_g = max(acc_static(:,1));

g_table = [zero_g; one_g];
g_vals = [0; 1];

g = @(n_val) to_g(g_table,g_vals,n_val);
a = @(n_val) 9.8*g(n_val);

acc_g = g(acc);

%% High pass filter

cut_off_freq = 1.5;   % [Hz]
Ny_freq = 1/2/T;    % [Hz]

butter_order = 10;
butter_freq  = cut_off_freq/Ny_freq;
[B,A] = butter(butter_order,butter_freq,'high');
filtered_g = filter(B,A,acc_g);

% hold on
% plot(t,acc_g)
% plot(t,filtered_g,'k')
% hold off

%% V Integration and filtering

v = cumtrapz(t,filtered_g);

filtered_v = filter(B,A,v);

% hold on
% plot(t,v)
% plot(t,filtered_v,'k')
% hold off

%% X Integration and filtering

x = cumtrapz(t,filtered_v) + 2e-2;
filtered_x = filter(B,A,x);

hold on
% plot(t,9.8*x)
plot(t,9.8*filtered_g/((2*pi*2)^2),'k')
plot(t,9.8*filtered_x)
hold off